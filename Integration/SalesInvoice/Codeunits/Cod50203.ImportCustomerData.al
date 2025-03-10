codeunit 50203 "Import Customer Data"
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

                    if pCSVBuffer."Field No." in [ColumnCustomerNumber] then begin //Check for required columns to be filled in
                        if (pCSVBuffer.Value = '') then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Non-blank value', pCSVBuffer.Value));
                        end;
                    end;
                    /*if pCSVBuffer."Field No." in [ColumnDateShipped, ColumnInvoiceDate, ColumnDueDate] then begin
                        if not CheckDate(pCSVBuffer.Value, lDateVar) then begin
                            pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Date (MM/DD/YYYY)', pCSVBuffer.Value));
                        end;
                    end;*/

                    if (pCSVBuffer."Field No." in [ColumnCreditLimit]) and (pCSVBuffer.Value <> '') then begin
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


    procedure SetColumnNumbers()
    begin
        TotalColumns := 32; //number of columns expected in file
        HeaderRow := true; //is there a header row?
        ColumnCustomerNumber := 1;
        ColumnCustomerName := 2;
        ColumnAddress1 := 3;
        ColumnAddress2 := 4;
        ColumnAddress3 := 5;
        ColumnAddress4 := 6;
        ColumnCity := 7;
        ColumnState := 8;
        ColumnZipCode := 9;
        ColumnStatementCode := 10;
        ColumnShipVia := 11;
        ColumnSearchName := 12;
        ColumnCreditLimit := 13;
        ColumnFaxNumber := 14;
        ColumnPhoneNumber := 15;
        ColumnContact := 16;
        ColumnTaxCode := 17;
        ColumnCountryCode := 18;
        ColumnSalespersonCode := 19;
        ColumnPaymentTerms := 20;
        ColumnComment0 := 21;
        ColumnSpecialInstruction1 := 22;
        ColumnSpecialInstructions2 := 23;
        ColumnTaxable := 24;
        ColumnCustomerType := 25;
        ColumnEmailAddress := 26;
        ColumnComment1 := 27;
        ColumnComment2 := 28;
        ColumnComment3 := 29;
        ColumnARCheckName := 30;
        ColumnCustomerTypeGroup := 31;
        ColumnSpecialInstructions3 := 32;
    end;

    var
        TotalColumns: Integer;
        HeaderRow: Boolean;
        WrongNumberOfColumnsErr: Label 'Wrong number of columns in file. Expected :%1, received: %2';
        FieldValueErr: Label 'Line %1, Field %2 error: Expected %3, received %4';
        ColumnCustomerNumber: Integer;
        ColumnCustomerName: Integer;
        ColumnAddress1: Integer;
        ColumnAddress2: Integer;
        ColumnAddress3: Integer;
        ColumnAddress4: Integer;
        ColumnCity: Integer;
        ColumnState: Integer;
        ColumnZipCode: Integer;
        ColumnStatementCode: Integer;
        ColumnShipVia: Integer;
        ColumnSearchName: Integer;
        ColumnCreditLimit: Integer;
        ColumnFaxNumber: Integer;
        ColumnPhoneNumber: Integer;
        ColumnContact: Integer;
        ColumnTaxCode: Integer;
        ColumnCountryCode: Integer;
        ColumnSalespersonCode: Integer;
        ColumnPaymentTerms: Integer;
        ColumnComment0: Integer;
        ColumnSpecialInstruction1: Integer;
        ColumnSpecialInstructions2: Integer;
        ColumnTaxable: Integer;
        ColumnCustomerType: Integer;
        ColumnEmailAddress: Integer;
        ColumnComment1: Integer;
        ColumnComment2: Integer;
        ColumnComment3: Integer;
        ColumnARCheckName: Integer;
        ColumnCustomerTypeGroup: Integer;
        ColumnSpecialInstructions3: Integer;

}
