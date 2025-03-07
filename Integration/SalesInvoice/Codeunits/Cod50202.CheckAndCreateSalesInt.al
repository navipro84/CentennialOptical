codeunit 50202 "Check And Create - Sales Int."
{
    procedure CheckAllOrders()
    var
        lSalesIntHeader: Record "Sales Integration Header";
    begin
        Clear(lSalesIntHeader);
        lSalesIntHeader.SetCurrentKey("Order Processed", "Error In Order");
        lSalesIntHeader.SetRange("Order Processed", false);
        lSalesIntHeader.SetRange("Error In Order", false);
        if lSalesIntHeader.FindSet(true) then
            repeat
                CheckSalesIntOrder(lSalesIntHeader);

            until lSalesIntHeader.Next = 0;



    end;

    procedure CheckSalesIntOrder(var pSalesIntHeader: Record "Sales Integration Header")
    var
        lCustomer: Record "Customer";
        lErrorInOrder: Boolean;
        lSalesperson: Record "Salesperson/Purchaser";
        lPaymentTerms: Record "Payment Terms";
    begin
        //Check Customer
        if lCustomer.Get(pSalesIntHeader."Sell-To Customer No.") then begin
            if lCustomer.Blocked <> lCustomer.Blocked::" " then
                EnterError(pSalesIntHeader, 0, StrSubstNo(CustomerIsBlockedErr, lCustomer.Blocked));
        end else begin
            EnterError(pSalesIntHeader, 0, CustDoesNotExistErr);
        end;
        if pSalesIntHeader."Salesperson Code" <> '' then
            if not lSalesperson.Get(pSalesIntHeader."Salesperson Code") then
                EnterError(pSalesIntHeader, 0, StrSubstNo(SalespersonDoesNotExistsErr, pSalesIntHeader."Salesperson Code"));

        if pSalesIntHeader."Payment Terms Code" <> '' then
            if not lPaymentTerms.Get(pSalesIntHeader."Payment Terms Code") then
                EnterError(pSalesIntHeader, 0, StrSubstNo(PaymentTermsNotExistsErr, pSalesIntHeader."Payment Terms Code"));

    end;

    procedure EnterError(pSalesIntHeader: Record "Sales Integration Header"; pOrderLineNo: Integer; pErrorText: Text)
    var
        lIntegErrorLine: Record "Integration Error Line";
        lNewLineNo: Integer;
    begin
        Clear(lIntegErrorLine);
        lIntegErrorLine.SetRange("Integration Import No.", pSalesIntHeader."Import No.");
        lIntegErrorLine.SetRange("Integration File No.", pSalesIntHeader."File No.");
        lIntegErrorLine.SetRange("Integration Order No.", pSalesIntHeader."Order No.");
        lIntegErrorLine.SetRange("Line No.", pOrderLineNo);
        If lIntegErrorLine.FindLast() then
            lNewLineNo := lIntegErrorLine."Error Line No." + 1
        else
            lNewLineNo := 1;
        lIntegErrorLine."Integration Import No." := pSalesIntHeader."Import No.";
        lIntegErrorLine."Integration File No." := pSalesIntHeader."File No.";
        lIntegErrorLine."Integration Order No." := pSalesIntHeader."Order No.";
        lIntegErrorLine."Line No." := pOrderLineNo; //0=Error is realted to header
        lIntegErrorLine."Error Line No." := lNewLineNo;
        lIntegErrorLine."Integration Type" := lIntegErrorLine."Integration Type"::Sales;
        lIntegErrorLine."Error Description" := pErrorText;
        lIntegErrorLine."Created DateTime" := CurrentDateTime;
        lIntegErrorLine.Insert;

        if not pSalesIntHeader."Error In Order" then begin
            pSalesIntHeader."Error In Order" := true;
            pSalesIntHeader.Modify;
        end;
    end;

    var
        CustDoesNotExistErr: Label 'Customer does not exist';
        CustomerIsBlockedErr: Label 'Customer is blocked with %1';
        SalespersonDoesNotExistsErr: Label 'Salesperson %1 does not exist';
        PaymentTermsNotExistsErr: Label 'Payment Terms %1 does not exist';
}
