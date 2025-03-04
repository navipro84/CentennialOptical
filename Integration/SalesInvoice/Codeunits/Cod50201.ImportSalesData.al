codeunit 50201 ImportSalesData
{

    procedure StartImport(pCSVBuffer: Record "CSV Buffer"; var pRecordsCounter: Integer; var pErrorsCounter: Integer; var pCriticalErrorText: List of [Text])
    begin
        SetColumnNumbers();
        if not CheckForCriticalErrors(pCSVBuffer, pCriticalErrorText) then //if critical error in file
            exit;
        CreateImportDocuments(pCSVBuffer, pRecordsCounter, pErrorsCounter);

    end;

    procedure CheckForCriticalErrors(pCSVBuffer: Record "CSV Buffer"; var pCriticalErrorText: List of [Text]): Boolean
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
                if pCSVBuffer."Field No." = ColumnDocumentType then begin
                    if (pCSVBuffer.Value <> 'Invoice') and (pCSVBuffer.Value <> 'Credit') then begin
                        pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Invoice or Credit', pCSVBuffer.Value));
                    end;
                end;
                if pCSVBuffer."Field No." = ColumnDateShipped then begin
                    if not CheckDate(pCSVBuffer.Value, lDateVar) then begin
                        pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Date (MM/DD/YYYY)', pCSVBuffer.Value));
                    end;
                end;
                if pCSVBuffer."Field No." = ColumnTotalMerchAmount then begin
                    if not Evaluate(lDecimalVar, pCSVBuffer.Value) then begin
                        pCriticalErrorText.Add(StrSubstNo(FieldValueErr, pCSVBuffer."Line No.", pCSVBuffer."Field No.", 'Decimal', pCSVBuffer.Value));
                    end;
                end;


            until pCSVBuffer.Next = 0;
        exit(pCriticalErrorText.Count = 0);
    end;

    procedure CreateImportDocuments(pCSVBuffer: Record "CSV Buffer"; var pRecordsCounter: Integer; var pErrorsCounter: Integer)
    begin

    end;

    [TryFunction]
    procedure CheckDate(pDateText: Text; var pDate: Date)
    var
        lMonthInt: Integer;
        lDayInt: Integer;
        lYearInt: Integer;
    begin
        //DD/MM/YYYY
        Evaluate(lDayInt, CopyStr(pDateText, 1, 2));
        Evaluate(lMonthInt, CopyStr(pDateText, 3, 2));
        Evaluate(lYearInt, CopyStr(pDateText, 78, 4));
        pDate := DMY2Date(lDayInt, lMonthInt, lYearInt);
    end;

    procedure SetColumnNumbers()
    begin
        TotalColumns := 58; //number of columns expected in file
        HeaderRow := true; //is there a header row?
        ColumnDocumentType := 1;
        ColumnInvoiceNumber := 2;
        ColumnDateShipped := 3;
        ColumnCustomerNo := 4;
        ColumnExtCustomerName := 5;
        ColumnTotalMerchAmount := 6;
        ColumnTotalTaxAmount := 7;
        ColumnTotalOtherAmount := 8;
        ColumnTotalMiscCharges := 9;
        ColumnTotalFreightAmount := 10;
        ColumnOutsideSalespersonCode := 11;
        ColumnTaxCode := 13;
        ColumnOriginalOrderInvoice := 15; //On credit memo lines, this number shows original Invoice #
        ColumnCustomerPO := 16;
        ColumnInvoiceDate := 17; //Posting Date
        ColumnDueDate := 18;
        ColumnTotalCost := 21;
        ColumnPaymentTermsCode := 22;
        ColumnMiscChargeCode1 := 25;
        ColumnMiscChargeCode2 := 26;
        ColumnMiscChargeCode3 := 27;
        ColumnMiscChargeAmount1 := 28;
        ColumnMiscChargeAmount2 := 29;
        ColumnMiscChargeAmount3 := 30;
        ColumnStateTaxAmount := 33;
        ColumnTotalCountyTaxAmount := 34;
        ColumnTotalCityTaxAmount := 35;
        ColumnTotalSchoolTaxAmount := 36;
        ColumnTotalOtherTaxAmount := 37;
        ColumnItemNo := 40;
        ColumnItemDescription1 := 41;
        ColumnItemDescription2 := 42;
        ColumnQtyOrdered := 43;
        ColumnQtyShipped := 44;
        ColumnLineAmount := 46;
        ColumnUnitCost := 49;
        ColumnTaxable := 51;
        ColumnLineTotalCost := 52;
        ColumnLineStateTaxAmount := 56;
        ColumnLineCountyTax := 57;
        ColumnLineCityTax := 58;
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
        ColumnTotalMiscCharges: Integer;
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
        ColumnStateTaxAmount: Integer;
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
        ColumnLineCountyTax: Integer;
        ColumnLineCityTax: Integer;
        TotalColumns: Integer;
        HeaderRow: Boolean;
        WrongNumberOfColumnsErr: Label 'Wrong number of columns in file. Expected :%1, received: %2';
        FieldValueErr: Label 'Line %1, Field %2 error: Expected %3, received %4';
}
