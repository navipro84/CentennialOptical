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
                field("Import No"; Rec."Import No")
                {
                    ToolTip = 'Specifies the value of the Import No. field.', Comment = '%';
                    Caption = 'Import No.';
                }
                field("File No."; Rec."File No.")
                {
                    Visible = false;
                    Caption = 'File No.';
                }

                field("File Name "; Rec."File Name ")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                    Style = Attention;
                    StyleExpr = (Rec."Error in Order");
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("External Invoice No."; Rec."External Document No.")
                {
                    Style = Attention;
                    StyleExpr = (Rec."Error in Order");
                }
                field("Original Order No."; Rec."Original Order No.")
                {
                    ToolTip = 'Specifies the value of the Original Order No. field.', Comment = '%';
                }

                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                }
                field("External Customer Name"; Rec."External Customer Name")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies the value of the Payment Terms Code field.', Comment = '%';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field.', Comment = '%';
                }


                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("Customer PO"; Rec."Customer PO")
                {
                }
                field("Misc Charge 1 Code"; Rec."Misc Charge 1 Code")
                {
                    ToolTip = 'Specifies the value of the Misc Charge 1 Code field.', Comment = '%';
                }
                field("Misc Charge 1 Amount"; Rec."Misc Charge 1 Amount")
                {
                    ToolTip = 'Specifies the value of the Misc Charge 1 Amount field.', Comment = '%';
                }
                field("Misc Charge 2 Code"; Rec."Misc Charge 2 Code")
                {
                    ToolTip = 'Specifies the value of the Misc Charge 1 Code field.', Comment = '%';
                }
                field("Misc Charge 2 Amount"; Rec."Misc Charge 2 Amount")
                {
                    ToolTip = 'Specifies the value of the Misc Charge 1 Amount field.', Comment = '%';
                }
                field("Misc Charge 3 Code"; Rec."Misc Charge 3 Code")
                {
                    ToolTip = 'Specifies the value of the Misc Charge 3 Code field.', Comment = '%';
                }
                field("Misc Charge 3 Amount"; Rec."Misc Charge 3 Amount")
                {
                    ToolTip = 'Specifies the value of the Misc Charge 3 Amount field.', Comment = '%';
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ToolTip = 'Specifies the value of the Tax Code field.', Comment = '%';
                }

                field("Imported Date Time"; Rec."Imported Date Time")
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
                field("Errors in Order"; Rec."Errors in Order")
                {
                    ToolTip = 'Specifies the value of the Errors in Order field.', Comment = '%';
                }
            }
            part(SalesIntLines; "Sales Integration Line Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Import No." = field("Import No"), "File No." = field("File No."), "Order No." = field("Order No.");
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
                //RawToBuffer: Codeunit "Raw to Buffer Transfer";
                begin
                    //RawToBuffer.CheckCreateSalesIntegrationOrders();
                end;
            }
            action(ResetError)
            {
                ApplicationArea = All;
                Caption = 'Reset Error';
                Image = ErrorFALedgerEntries;

                trigger OnAction();
                var
                //RawToBuffer: Codeunit "Raw to Buffer Transfer";
                begin
                    //RawToBuffer.ResetOrderErrors(Rec);
                end;
            }
        }
    }
}
