page 50021 "Integration Imports"
{
    ApplicationArea = All;
    Caption = 'Integration Imports';
    PageType = List;
    SourceTable = "Integration Import";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Import No."; Rec."Import No.")
                {
                    ToolTip = 'Specifies the value of the Import No. field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Critical Error in Import" or (Rec."Errors in Import" > 0));
                    Caption = 'Import No.';
                }
                field("Files in Import"; Rec."Files in Import")
                {
                    ToolTip = 'Specifies the value of the Files Processed field.', Comment = '%';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Critical Error in Import" or (Rec."Errors in Import" > 0));
                }
                field("Integration Type"; Rec."Integration Type")
                {
                    ToolTip = 'Specifies the value of the Integration Type field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Critical Error in Import" or (Rec."Errors in Import" > 0));
                }

                field("Processed Date Time"; Rec."Processed Date Time")
                {
                    ToolTip = 'Specifies the value of the Processed Date Time field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Critical Error in Import" or (Rec."Errors in Import" > 0));
                }
                field("Files Processed"; Rec."Files Processed")
                {
                    ToolTip = 'Specifies the value of the Files Processed field.', Comment = '%';
                }
                field("File Orders Imported"; Rec."File Orders Imported")
                {
                    ToolTip = 'Specifies the value of the File Lines Imported field.', Comment = '%';
                }
                field("File Lines Imported"; Rec."File Lines Imported")
                {
                    ToolTip = 'Specifies the value of the File Lines Imported field.', Comment = '%';
                }

                field("Errors in Import"; Rec."Errors in Import")
                {
                    ToolTip = 'Specifies the value of the Errors in Import field.', Comment = '%';
                    BlankZero = true;
                    Style = Attention;
                }
                field("Critical Error in Import"; Rec."Critical Error in Import")
                {
                    ToolTip = 'Specifies the value of the Critical Errors in Import field.', Comment = '%';
                }



            }
            part(IntegImportFiles; "Integ. Import Files Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Import No." = field("Import No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ShowOrders)
            {
                ApplicationArea = All;
                Caption = 'Show Orders';
                Image = OrderList;

                trigger OnAction();
                var
                    SalesIntOrderPage: Page "Sales Integration Orders";
                    SalesIntHeader: Record "Sales Integration Header";
                    NoOrdersinImportMsg: Label 'There is no orders in Import %1';
                begin
                    case rec."Integration Type" of
                        rec."Integration Type"::Sales:
                            begin
                                Clear(SalesIntHeader);
                                SalesIntHeader.SetRange("Import No", Rec."Import No.");
                                if SalesIntHeader.FindSet(false) then
                                    Page.Run(0, SalesIntHeader)
                                else
                                    Message(NoOrdersinImportMsg, Rec."Import No.");
                            end;
                    end;
                end;

            }
            action(CreateImportFromAzure)
            {
                ApplicationArea = All;
                Caption = 'Import from Azure';
                Image = CreateDocuments;

                trigger OnAction();
                var
                    ImportFromADS: Codeunit "Import File from ADS";
                    IntegrationType: Enum "Integration Type";
                begin
                    ImportFromADS.AuthorizeAzure(IntegrationType::Sales);
                    ImportFromADS.ImportFromAzure(IntegrationType::Sales);
                end;
            }

        }
        area(Promoted)
        {
            actionref(Show_Orders; ShowOrders) { }
        }
    }
}
