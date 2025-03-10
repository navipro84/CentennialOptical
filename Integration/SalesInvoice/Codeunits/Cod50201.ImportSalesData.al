codeunit 50201 "Import Sales Data"
{

    procedure StartImport(var pCSVBuffer: Record "CSV Buffer" temporary; pIntegrationImportFile: record "Integration Import File"; var pFileLineCounter: Integer;
                            var pErrorsCounter: Integer; var pCriticalErrorText: List of [Text]; var pFileOrderCounter: Integer)
    begin
        SetColumnNumbers();
        if not CheckForCriticalErrors(pCSVBuffer, pCriticalErrorText) then //if critical error in file
            exit;
        CreateImportDocuments(pCSVBuffer, pIntegrationImportFile, pFileLineCounter, pErrorsCounter, pFileOrderCounter);
    end;

    procedure CheckForCriticalErrors(var pCSVBuffer: Record "CSV Buffer" temporary; var pCriticalErrorText: List of [Text]): Boolean
    var
        lDateVar: Date;
        lDecimalVar: Decimal;
    begin
        if pCSVBuffer.GetNumberOfColumns() <> TotalColumns then begin
            pCriticalErrorText.Add(StrSubstNo(WrongNumberOfColumnsErr, TotalColumns, pCSVBuffer.GetNumberOfColumns()));
            exit(false);
        end;

        if pCSVBuffer.FindSet then
            repeat
                if not (HeaderRow and (pCSVBuffer."Line No." = 1)) then begin//skip header row if there
                    if pCSVBuffer."Field No." = ColumnDocumentType then begin
                        if (pCSVBuffer.Value <> 'Invoice') and (pCSVBuffer.Value <> 'Credit') then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Invoice or Credit', pCSVBuffer.Value));
                        end;
                    end;
                    if pCSVBuffer."Field No." in [ColumnInvoiceNumber] then begin //Check for required columns to be filled in
                        if (pCSVBuffer.Value = '') then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Non-blank value', pCSVBuffer.Value));
                        end;
                    end;
                    if pCSVBuffer."Field No." in [ColumnDateShipped, ColumnInvoiceDate, ColumnDueDate] then begin
                        if not CheckDate(pCSVBuffer.Value, lDateVar) then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Date (MM/DD/YYYY)', pCSVBuffer.Value));
                        end;
                    end;

                    if (pCSVBuffer."Field No." in [ColumnTotalMerchAmount, ColumnTotalTaxAmount, ColumnTotalMiscAmount, ColumnTotalFreightAmount,
                                                    ColumnTotalCost, ColumnMiscChargeAmount1, ColumnMiscChargeAmount2, ColumnMiscChargeAmount3,
                                                    ColumnTotalStateTaxAmount, ColumnTotalCountyTaxAmount, ColumnTotalCityTaxAmount,
                                                    ColumnTotalSchoolTaxAmount, ColumnTotalOtherAmount, ColumnQtyOrdered, ColumnQtyShipped,
                                                    ColumnLineAmount, ColumnUnitCost, ColumnLineTotalCost, ColumnLineStateTaxAmount,
                                                    ColumnLineCountyTaxAmount, ColumnLineCityTaxAmount,
                                                    ColumnLineSchoolTaxAmount, ColumnLineOtherTaxAmount]) and (pCSVBuffer.Value <> '') then begin
                        if not Evaluate(lDecimalVar, pCSVBuffer.Value) then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Decimal', pCSVBuffer.Value));
                        end;
                    end;


                    if (pCSVBuffer."Field No." = ColumnTaxable) and (pCSVBuffer.Value <> '') then begin
                        if (pCSVBuffer.Value <> 'Y') and (pCSVBuffer.Value <> 'N') then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Y, N, Blank', pCSVBuffer.Value));
                        end;
                    end;
                end;
            until pCSVBuffer.Next = 0;
        exit(pCriticalErrorText.Count = 0);
    end;

    procedure CreateImportDocuments(var pCSVBuffer: Record "CSV Buffer" temporary; pIntegrationImportFile: Record "Integration Import File";
                                    var pFileLineCounter: Integer; var pErrorsCounter: Integer; var pFileOrderCounter: Integer)
    var
        lDocumentNo: Code[50];
        lStartingRow: Integer;
        i: Integer;
        lSalesIntHeader: Record "Sales Integration Header";
        lSalesIntLine: Record "Sales Integration Line";
        lNewOrderNo: Code[20];
        lLineNo: Integer;
    begin
        if HeaderRow then
            lStartingRow := 2
        else
            lStartingRow := 1;
        lNewOrderNo := 'ORD000001';
        if pCSVBuffer.GetNumberOfLines() >= lStartingRow then
            for i := lStartingRow to pCSVBuffer.GetNumberOfLines() do begin
                if pCSVBuffer.GetValue(i, ColumnInvoiceNumber) <> lDocumentNo then begin
                    //new document# -> create header
                    lDocumentNo := pCSVBuffer.GetValue(i, ColumnInvoiceNumber);
                    pFileOrderCounter += 1;
                    Clear(lSalesIntHeader);
                    lSalesIntHeader."Import No." := pIntegrationImportFile."Import No.";
                    lSalesIntHeader."File No." := pIntegrationImportFile."File No.";
                    lSalesIntHeader."File Name " := pIntegrationImportFile."File Name";
                    lSalesIntHeader."Order No." := lNewOrderNo;
                    lNewOrderNo := IncStr(lNewOrderNo);
                    lSalesIntHeader."External Document No." := pCSVBuffer.GetValue(i, ColumnInvoiceNumber);
                    if CopyStr(lSalesIntHeader."External Document No.", StrLen(lSalesIntHeader."External Document No."), 1) = 'C' then //if the last letter is C -> Credit
                        lSalesIntHeader."Document Type" := lSalesIntHeader."Document Type"::Credit;
                    if CopyStr(lSalesIntHeader."External Document No.", StrLen(lSalesIntHeader."External Document No."), 1) = 'D' then //if the last letter is D -> Debit Memo
                        lSalesIntHeader."Document Type" := lSalesIntHeader."Document Type"::"Debit Memo";
                    CheckDate(pCSVBuffer.GetValue(i, ColumnDateShipped), lSalesIntHeader."Shipment Date");
                    lSalesIntHeader."Sell-To Customer No." := pCSVBuffer.GetValue(i, ColumnCustomerNo);
                    lSalesIntHeader."External Customer Name" := pCSVBuffer.GetValue(i, ColumnExtCustomerName);
                    CheckDate(pCSVBuffer.GetValue(i, ColumnInvoiceDate), lSalesIntHeader."Invoice Date");
                    CheckDate(pCSVBuffer.GetValue(i, ColumnDueDate), lSalesIntHeader."Due Date");
                    lSalesIntHeader."Customer PO" := pCSVBuffer.GetValue(i, ColumnCustomerPO);
                    lSalesIntHeader."Original Order No." := pCSVBuffer.GetValue(i, ColumnOriginalOrderInvoice);
                    lSalesIntHeader."Payment Terms Code" := pCSVBuffer.GetValue(i, ColumnPaymentTermsCode);
                    lSalesIntHeader."Salesperson Code" := pCSVBuffer.GetValue(i, ColumnOutsideSalespersonCode);
                    lSalesIntHeader."Tax Code" := pCSVBuffer.GetValue(i, ColumnTaxCode);
                    lSalesIntHeader."Misc Charge 1 Code" := pCSVBuffer.GetValue(i, ColumnMiscChargeCode1);
                    lSalesIntHeader."Misc Charge 2 Code" := pCSVBuffer.GetValue(i, ColumnMiscChargeCode2);
                    lSalesIntHeader."Misc Charge 3 Code" := pCSVBuffer.GetValue(i, ColumnMiscChargeCode3);
                    Evaluate(lSalesIntHeader."Misc Charge 1 Amount", pCSVBuffer.GetValue(i, ColumnMiscChargeAmount1));
                    Evaluate(lSalesIntHeader."Misc Charge 2 Amount", pCSVBuffer.GetValue(i, ColumnMiscChargeAmount2));
                    Evaluate(lSalesIntHeader."Misc Charge 3 Amount", pCSVBuffer.GetValue(i, ColumnMiscChargeAmount3));
                    lSalesIntHeader."Imported Date Time" := CurrentDateTime;
                    lSalesIntHeader.Insert;
                    lLineNo := 10000;
                end;
                if pCSVBuffer.GetValue(i, ColumnInvoiceLineKey) <> '' then begin //check is the invoice line key is blank
                    Clear(lSalesIntLine);
                    lSalesIntLine."Import No." := lSalesIntHeader."Import No.";
                    lSalesIntLine."File No." := lSalesIntHeader."File No.";
                    lSalesIntLine."Order No." := lSalesIntHeader."Order No.";
                    lSalesIntLine."Line No." := lLineNo;
                    lLineNo += 10000;
                    lSalesIntLine."Item No." := pCSVBuffer.GetValue(i, ColumnItemNo);
                    lSalesIntLine."Item Description" := pCSVBuffer.GetValue(i, ColumnItemDescription1);
                    lSalesIntLine."Item Description 2" := pCSVBuffer.GetValue(i, ColumnItemDescription2);
                    lSalesIntLine."Customer Item No." := pCSVBuffer.GetValue(i, ColumnCustomerItemNo);
                    lSalesIntLine."Unit of Measure" := pCSVBuffer.GetValue(i, ColumnUnitOfMeasure);
                    Evaluate(lSalesIntLine."Quantity Ordered", pCSVBuffer.GetValue(i, ColumnQtyOrdered));
                    Evaluate(lSalesIntLine."Quantity Shipped", pCSVBuffer.GetValue(i, ColumnQtyShipped));
                    Evaluate(lSalesIntLine."Line Amount", pCSVBuffer.GetValue(i, ColumnLineAmount));
                    Evaluate(lSalesIntLine."Unit Cost", pCSVBuffer.GetValue(i, ColumnUnitCost));
                    Evaluate(lSalesIntLine."Line Cost", pCSVBuffer.GetValue(i, ColumnLineTotalCost));
                    Evaluate(lSalesIntLine."State Tax Amount", pCSVBuffer.GetValue(i, ColumnLineStateTaxAmount));
                    Evaluate(lSalesIntLine."County Tax Amount", pCSVBuffer.GetValue(i, ColumnLineCountyTaxAmount));
                    Evaluate(lSalesIntLine."City Tax Amount", pCSVBuffer.GetValue(i, ColumnLineCityTaxAmount));
                    Evaluate(lSalesIntLine."School Tax Amount", pCSVBuffer.GetValue(i, ColumnLineSchoolTaxAmount));
                    Evaluate(lSalesIntLine."Other Tax Amount", pCSVBuffer.GetValue(i, ColumnLineOtherTaxAmount));
                    if pCSVBuffer.GetValue(i, ColumnTaxable) = 'Y' then
                        lSalesIntLine.Taxable := true;
                    lSalesIntLine.Insert;
                end;

            end;
        pFileLineCounter := i;

    end;


    [TryFunction]
    procedure CheckDate(pDateText: Text; var pDate: Date)
    var
        lMonthInt: Integer;
        lDayInt: Integer;
        lYearInt: Integer;
    begin
        //DD/MM/YYYY
        Evaluate(lDayInt, CopyStr(pDateText, 4, 2));
        Evaluate(lMonthInt, CopyStr(pDateText, 1, 2));
        Evaluate(lYearInt, CopyStr(pDateText, 7, 4));
        pDate := DMY2Date(lDayInt, lMonthInt, lYearInt);
    end;

    procedure SetColumnNumbers()
    begin
        TotalColumns := 62; //number of columns expected in file
        HeaderRow := true; //is there a header row?
        //ColumnDocumentType := 0;
        ColumnInvoiceNumber := 1;
        ColumnDateShipped := 2;
        ColumnCustomerNo := 3;
        ColumnExtCustomerName := 4;
        ColumnTotalMerchAmount := 5;
        ColumnTotalTaxAmount := 6;
        ColumnTotalOtherAmount := 7;
        ColumnTotalMiscAmount := 8;
        ColumnTotalFreightAmount := 9;
        ColumnOutsideSalespersonCode := 10;
        ColumnTaxCode := 12;
        ColumnOriginalOrderInvoice := 14; //On credit memo lines, this number shows original Invoice #
        ColumnCustomerPO := 15;
        ColumnInvoiceDate := 16; //Posting Date
        ColumnDueDate := 17;
        ColumnTotalCost := 20;
        ColumnPaymentTermsCode := 21;
        ColumnMiscChargeCode1 := 24;
        ColumnMiscChargeCode2 := 25;
        ColumnMiscChargeCode3 := 26;
        ColumnMiscChargeAmount1 := 27;
        ColumnMiscChargeAmount2 := 28;
        ColumnMiscChargeAmount3 := 29;
        ColumnTotalStateTaxAmount := 32;
        ColumnTotalCountyTaxAmount := 33;
        ColumnTotalCityTaxAmount := 34;
        ColumnTotalSchoolTaxAmount := 35;
        ColumnTotalOtherTaxAmount := 36;
        ColumnInvoiceLineKey := 39;
        ColumnItemNo := 40;
        ColumnItemDescription1 := 41;
        ColumnItemDescription2 := 42;
        ColumnQtyOrdered := 43;
        ColumnQtyShipped := 44;
        ColumnLineAmount := 46;
        ColumnCustomerItemNo := 47;
        ColumnUnitOfMeasure := 48;
        ColumnUnitCost := 49;
        ColumnTaxable := 51;
        ColumnLineTotalCost := 52;
        ColumnLineStateTaxAmount := 58;
        ColumnLineCountyTaxAmount := 59;
        ColumnLineCityTaxAmount := 60;
        ColumnLineSchoolTaxAmount := 61;
        ColumnLineOtherTaxAmount := 62;
    end;

    var
        ColumnDocumentType: Integer;
        ColumnInvoiceNumber: Integer;
        ColumnDateShipped: Integer;
        ColumnCustomerNo: Integer;
        ColumnExtCustomerName: Integer;
        ColumnTotalMerchAmount: Integer;
        ColumnTotalTaxAmount: Integer;
        ColumnTotalOtherAmount: Integer;
        ColumnTotalMiscAmount: Integer;
        ColumnTotalFreightAmount: Integer;
        ColumnOutsideSalespersonCode: Integer;
        ColumnTaxCode: Integer;
        ColumnOriginalOrderInvoice: Integer;
        ColumnCustomerPO: Integer;
        ColumnInvoiceDate: Integer;
        ColumnDueDate: Integer;
        ColumnTotalCost: Integer;
        ColumnPaymentTermsCode: Integer;
        ColumnMiscChargeCode1: Integer;
        ColumnMiscChargeCode2: Integer;
        ColumnMiscChargeCode3: Integer;
        ColumnMiscChargeAmount1: Integer;
        ColumnMiscChargeAmount2: Integer;
        ColumnMiscChargeAmount3: Integer;
        ColumnTotalStateTaxAmount: Integer;
        ColumnTotalCountyTaxAmount: Integer;
        ColumnTotalCityTaxAmount: Integer;
        ColumnTotalSchoolTaxAmount: Integer;
        ColumnTotalOtherTaxAmount: Integer;
        ColumnItemNo: Integer;
        ColumnItemDescription1: Integer;
        ColumnItemDescription2: Integer;
        ColumnQtyOrdered: Integer;
        ColumnQtyShipped: Integer;
        ColumnLineAmount: Integer;
        ColumnUnitCost: Integer;
        ColumnTaxable: Integer;
        ColumnLineTotalCost: Integer;
        ColumnLineStateTaxAmount: Integer;
        ColumnLineCountyTaxAmount: Integer;
        ColumnLineCityTaxAmount: Integer;
        TotalColumns: Integer;
        HeaderRow: Boolean;
        WrongNumberOfColumnsErr: Label 'Wrong number of columns in file. Expected :%1, received: %2';
        FieldValueErr: Label 'Line %1, Field %2 error: Expected %3, received %4';
        ColumnCustomerItemNo: Integer;
        ColumnUnitOfMeasure: Integer;
        ColumnInvoiceLineKey: Integer;
        ColumnLineSchoolTaxAmount: Integer;
        ColumnLineOtherTaxAmount: Integer;
}
