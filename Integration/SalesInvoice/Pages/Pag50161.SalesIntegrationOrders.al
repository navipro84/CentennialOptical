page 50161 "Sales Integration Orders"
{
    ApplicationArea = All;
    Caption = 'Sales Integration Orders';
    PageType = ListPlus;
    SourceTable = "Sales Integration Header";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File No."; Rec."File No.")
                {
                    Visible = false;
                }
                field("File Name "; Rec."File Name ")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                    Style = Attention;
                    StyleExpr = (Rec."Error in Order" or Rec."Critical Error In Order");
                }
                field("Int. Invoice No."; Rec."Int. Invoice No.")
                {
                    Style = Attention;
                    StyleExpr = (Rec."Error in Order" or Rec."Critical Error In Order");
                }
                field("Bill-To Customer No."; Rec."Bill-To Customer No.")
                {
                    Visible = false;
                }
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                }
                field("Int. Customer Name"; Rec."Int. Customer Name")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Visible = false;
                }
                field("Customer PO"; Rec."Customer PO")
                {
                }
                field("File Loaded Date Time"; Rec."File Loaded Date Time")
                {
                    Visible = false;
                }
                field("Order Processed"; Rec."Order Processed")
                {
                }
                field("Order Processed Date Time"; Rec."Order Processed Date Time")
                {
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    Visible = false;
                }
                field("Sales Document No."; Rec."Sales Document No.")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Visible = false;
                }
                field("Error In Order"; Rec."Error In Order")
                {
                }
                field("Critical Error In Order"; Rec."Critical Error In Order")
                {
                }
                field("Errors in Order"; Rec."Errors in Order")
                {
                    ToolTip = 'Specifies the value of the Errors in Order field.', Comment = '%';
                }
            }
            part(SalesIntLines; "Sales Integration Line Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "File No." = field("File No."), "Order No." = field("Order No.");
                UpdatePropagation = Both;
            }
        }



    }

    actions
    {
        area(Processing)
        {
            action(CreateSalesJournal)
            {
                ApplicationArea = All;
                Caption = 'Create Sales Journal';
                Image = CreateDocuments;

                trigger OnAction();
                var
                    RawToBuffer: Codeunit "Raw to Buffer Transfer";
                begin
                    RawToBuffer.CheckCreateSalesIntegrationOrders();
                end;
            }
            action(ResetError)
            {
                ApplicationArea = All;
                Caption = 'Reset Error';
                Image = ErrorFALedgerEntries;

                trigger OnAction();
                var
                    RawToBuffer: Codeunit "Raw to Buffer Transfer";
                begin
                    RawToBuffer.ResetOrderErrors(Rec);
                end;
            }
        }
    }
}
