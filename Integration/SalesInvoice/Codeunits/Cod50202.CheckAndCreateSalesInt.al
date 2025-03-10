 


codeunit 50202 "Check And Create - Sales Int."
{
    procedure CheckAndCreateAllOrders()
    var
        lSalesIntHeader: Record "Sales Integration Header";
        lIntSetup: Record "Integration Setup";
    begin
        //Check setups
        lIntSetup.Get(lIntSetup."Integration Type"::Sales);
        lIntSetup.TestField("State Tax G/L Account No.");
        lIntSetup.TestField("County Tax G/L Account No.");
        lIntSetup.TestField("City Tax G/L Account No.");
        lIntSetup.TestField("School Tax G/L Account No.");
        lIntSetup.TestField("Other Tax G/L Account No.");
        lIntSetup.TestField("Item Dimension Code");
        lIntSetup.TestField("Income G/L Account No.");
        lIntSetup.TestField("Inventory G/L Account No.");
        lIntSetup.TestField("COGS G/L Account No.");
        
        Clear(lSalesIntHeader);
        lSalesIntHeader.SetCurrentKey("Order Processed", "Error In Order");
        lSalesIntHeader.SetRange("Order Processed", false);
        lSalesIntHeader.SetRange("Error In Order", false);
        if lSalesIntHeader.FindSet(true) then
            repeat
                CheckSalesIntOrder(lSalesIntHeader);
                Commit;
                if not lSalesIntHeader."Error In Order" then begin
                    CreateAndPostInvoice(lSalesIntHeader);
                    Commit;
                end;
            until lSalesIntHeader.Next = 0;



    end;

    procedure CheckSalesIntOrder(var pSalesIntHeader: Record "Sales Integration Header")
    var
        lCustomer: Record "Customer";
        lErrorInOrder: Boolean;
        lSalesperson: Record "Salesperson/Purchaser";
        lPaymentTerms: Record "Payment Terms";
        lMiscCharge: Record "Misc Charge";
        lGLAccount: Record "G/L Account";
        lSalesIntLine: Record "Sales Integration Line";
        lDimensionValue: Record "Dimension Value";
        lIntSetup: Record "Integration Setup";
    begin
        lIntSetup.Get(lIntSetup."Integration Type"::Sales);
        
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
        if pSalesIntHeader."Misc Charge 1 Code" <> '' then
            if not lMiscCharge.Get(pSalesIntHeader."Misc Charge 1 Code") then begin
                EnterError(pSalesIntHeader, 0, StrSubstNo(MiscChargeNotExistsErr, pSalesIntHeader."Misc Charge 1 Code"));
            end else begin
                if lMiscCharge."G/L Account"<>'' then begin
                    if not lGLAccount.Get(lMiscCharge."G/L Account") then
                        EnterError(pSalesIntHeader, 0, StrSubstNo(GLMiscChargeNotExistsErr, lMiscCharge."G/L Account", lMiscCharge."Misc Charge Code"));
                end else
                    EnterError(pSalesIntHeader, 0, StrSubstNo(GLMiscChargeBlankErr, lMiscCharge."Misc Charge Code"));    
            end;
        if pSalesIntHeader."Misc Charge 2 Code" <> '' then
            if not lMiscCharge.Get(pSalesIntHeader."Misc Charge 2 Code") then begin
                EnterError(pSalesIntHeader, 0, StrSubstNo(MiscChargeNotExistsErr, pSalesIntHeader."Misc Charge 2 Code"));
            end else begin
                if lMiscCharge."G/L Account"<>'' then begin
                    if not lGLAccount.Get(lMiscCharge."G/L Account") then
                        EnterError(pSalesIntHeader, 0, StrSubstNo(GLMiscChargeNotExistsErr, lMiscCharge."G/L Account", lMiscCharge."Misc Charge Code"));
                end else
                    EnterError(pSalesIntHeader, 0, StrSubstNo(GLMiscChargeBlankErr, lMiscCharge."Misc Charge Code"));    
            end;
        if pSalesIntHeader."Misc Charge 3 Code" <> '' then
            if not lMiscCharge.Get(pSalesIntHeader."Misc Charge 3 Code") then begin
                EnterError(pSalesIntHeader, 0, StrSubstNo(MiscChargeNotExistsErr, pSalesIntHeader."Misc Charge 3 Code"));
            end else begin
                if lMiscCharge."G/L Account"<>'' then begin
                    if not lGLAccount.Get(lMiscCharge."G/L Account") then
                        EnterError(pSalesIntHeader, 0, StrSubstNo(GLMiscChargeNotExistsErr, lMiscCharge."G/L Account", lMiscCharge."Misc Charge Code"));
                end else
                    EnterError(pSalesIntHeader, 0, StrSubstNo(GLMiscChargeBlankErr, lMiscCharge."Misc Charge Code"));    
            end;

        //CheckLines
        Clear(lSalesIntLine);
        lSalesIntLine.SetRange("Import No.", pSalesIntHeader."Import No.");
        lSalesIntLine.SetRange("File No.", pSalesIntHeader."File No.");
        lSalesIntLine.SetRange("Order No.", pSalesIntHeader."Order No.");
        if lSalesIntLine.FindSet(false) then repeat
            //Check Item No. against dimension
            if not lDimensionValue.Get(lIntSetup."Item Dimension Code", lSalesIntLine."Item No.") then
                EnterError(pSalesIntHeader, lSalesIntLine."Line No.", StrSubstNo(DimensionValueNotExistErr, lSalesIntLine."Item No.")); 
           
        until lSalesIntLine.Next=0;
    end;

    procedure CreateAndPostInvoice(var pSalesIntHeader: Record "Sales Integration Header")
    var
        lSalesHeader: Record "Sales Header";
        lSalesLine: Record "Sales Line";
        lLineNo: Integer;
        lSalesIntline: Record "Sales Integration Line";
        lIntSetup: Record "Integration Setup";
        lDimentionMngt: Codeunit DimensionManagement;
    begin
        Clear(lSalesHeader);
        lSalesHeader."Document Type" := lSalesHeader."Document Type"::Invoice;
        lSalesHeader.Validate("Sell-to Customer No.", pSalesIntHeader."Sell-To Customer No.");
        lSalesHeader.Insert(true);
        if pSalesIntHeader."Payment Terms Code"<>'' then
            lSalesHeader.Validate("Payment Terms Code", pSalesIntHeader."Payment Terms Code");
        if pSalesIntHeader."Invoice Date"<>0D then
            lSalesHeader.Validate("Posting Date", pSalesIntHeader."Invoice Date");
        if pSalesIntHeader."Due Date"<>0D then
            lSalesHeader.Validate("Due Date", pSalesIntHeader."Due Date");
        if pSalesIntHeader."Salesperson Code"<>'' then
            lSalesHeader.Validate("Salesperson Code", pSalesIntHeader."Salesperson Code");
        if pSalesIntHeader."Shipment Date"<>0D then
            lSalesHeader.Validate("Shipment Date", pSalesIntHeader."Shipment Date");
        lSalesHeader.Modify(true);
        lLineNo := 0;
        if (pSalesIntHeader."Misc Charge 1 Code"<>'') and (pSalesIntHeader."Misc Charge 1 Amount"<>0) then begin            
            lLineNo += 10000;
            EnterMiscCharge(lSalesHeader, pSalesIntHeader."Misc Charge 1 Code", pSalesIntHeader."Misc Charge 1 Amount", lLineNo);        
        end;
        if (pSalesIntHeader."Misc Charge 2 Code"<>'') and (pSalesIntHeader."Misc Charge 2 Amount"<>0) then begin            
            lLineNo += 10000;
            EnterMiscCharge(lSalesHeader, pSalesIntHeader."Misc Charge 2 Code", pSalesIntHeader."Misc Charge 2 Amount", lLineNo);        
        end;
        if (pSalesIntHeader."Misc Charge 3 Code"<>'') and (pSalesIntHeader."Misc Charge 3 Amount"<>0) then begin            
            lLineNo += 10000;
            EnterMiscCharge(lSalesHeader, pSalesIntHeader."Misc Charge 3 Code", pSalesIntHeader."Misc Charge 3 Amount", lLineNo);        
        end;
        
        //Enter Lines
        Clear(lSalesIntline);
        lSalesIntline.SetRange("Import No.", pSalesIntHeader."Import No.");
        lSalesIntline.SetRange("File No.", pSalesIntHeader."File No.");
        lSalesIntline.SetRange("Order No.", pSalesIntHeader."Order No.");
        if lSalesIntline.FindSet(true) then repeat
            
            if (lSalesIntline."Item No."='') and (lSalesIntline."Item Description"<>'') then begin
                //Comment Line   
                lLineNo += 10000;
                Clear(lSalesLine);
                lSalesLine.Validate("Document Type", lSalesHeader."Document Type");
                lSalesLine.Validate("Document No.", lSalesHeader."No.");
                lSalesLine."Line No." := lLineNo;
                lSalesLine.Insert(true);
                lSalesLine.Validate(Type, lSalesLine.Type::" ");
                lSalesLine.Validate(Description, lSalesIntline."Item Description"+' ' + lSalesIntline."Item Description 2");
            end else begin
                //Income Line
                lLineNo += 10000;
                EnterSalesLine(lSalesIntLine, lSalesHeader, lLineNo, lIntSetup."Income G/L Account No.", 1, lSalesIntline."Line Amount");
                
                //Inventory Line
                lLineNo += 10000;
                EnterSalesLine(lSalesIntLine, lSalesHeader, lLineNo, lIntSetup."Inventory G/L Account No.", -1, lSalesIntline."Line Amount");
                
                //COGS Line
                lLineNo += 10000;
                EnterSalesLine(lSalesIntLine, lSalesHeader, lLineNo, lIntSetup."COGS G/L Account No.", 1, lSalesIntline."Line Amount");
             
                //TODO - add tax management
               
            end;

            lSalesLine.Modify(true);
        until lSalesIntline.Next=0;
    end;
    procedure EnterMiscCharge(pSalesHeader: Record "Sales Header"; pMiscChargeCode: Code[30]; pMiscChangeAmount: Decimal; pLineNo: Integer)
    var
        lSalesLine: Record "Sales Line";
        lMiscCharge: Record "Misc Charge";
    begin
        lMiscCharge.Get(pMiscChargeCode);
        Clear(lSalesLine);
        lSalesLine.Validate("Document Type", pSalesHeader."Document Type");
        lSalesLine.Validate("Document No.", pSalesHeader."No.");
        lSalesLine."Line No." := pLineNo;
        lSalesLine.Insert(true);
        lSalesLine.Validate(Type, lSalesLine.Type::"G/L Account");
        lSalesLine.Validate("No.", lMiscCharge."G/L Account");
        if lMiscCharge.Description<>'' then
            lSalesLine.Validate(Description, lMiscCharge.Description)
        else
            lSalesLine.Validate(Description, 'Misc Charge ' + lMiscCharge."Misc Charge Code");
        lSalesLine.Validate(Amount, pMiscChangeAmount);
        lSalesLine.Modify(true);
    end;

    procedure EnterSalesLine(pSalesIntline:Record "Sales Integration Line"; pSalesHeader: Record  "Sales Header"; 
                                pLineNo: Integer; pGLAccount:Code[20]; pQuantity:Decimal; pAmount:Decimal)
    var 
        lSalesLine: Record "Sales Line";
    begin
        Clear(lSalesLine);
        lSalesLine.Validate("Document Type", pSalesHeader."Document Type");
        lSalesLine.Validate("Document No.", pSalesHeader."No.");
        lSalesLine."Line No." := pLineNo;
        lSalesLine.Insert(true);
        lSalesLine.Validate(Type, lSalesLine.Type::"G/L Account");
        lSalesLine.Validate("No.", pGLAccount);
        lSalesLine.Validate(Quantity, pQuantity);
        lSalesLine.Validate(Amount, pAmount);
        lSalesLine.Validate(Description, pSalesIntline."Item Description");
        lSalesLine.Validate("Description 2", pSalesIntline."Item Description 2");
        lSalesLine.Modify(true);
        //TODO Deal with dimensions
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
        MiscChargeNotExistsErr: Label 'Misc Charge %1 does not exist';
        GLMiscChargeNotExistsErr: Label 'G/L Account (%1) specified in Misc Charge %2 does not exist';
        GLMiscChargeBlankErr: Label 'G/L Account specified in Misc Charge %1 is blank';
        DimensionValueNotExistErr: Label 'Dimension Value %1 does not exist';
}
