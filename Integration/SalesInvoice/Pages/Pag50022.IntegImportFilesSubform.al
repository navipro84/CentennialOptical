page 50022 "Integ. Import Files Subform"
{
    ApplicationArea = All;
    Caption = 'Integ. Import Files Subform';
    PageType = ListPart;
    SourceTable = "Integration Import File";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Critical Error in File" or (Rec."Errors in File" > 0));
                }
                field("File Length"; Rec."File Length")
                {
                    ToolTip = 'Specifies the value of the File Length field.', Comment = '%';
                }
                field("Errors in File"; Rec."Errors in File")
                {
                    ToolTip = 'Specifies the value of the Error in File field.', Comment = '%';
                    BlankZero = true;
                    Style = Attention;
                }

                field("File Orders Processed"; Rec."File Orders Imported")
                {
                    ToolTip = 'Specifies the value of the Records Processed field.', Comment = '%';
                }
                field("File Lines Processed"; Rec."File Lines Imported")
                {
                    ToolTip = 'Specifies the value of the Records Processed field.', Comment = '%';
                }
                field("Critical Error in File"; Rec."Critical Error in File")
                {
                    ToolTip = 'Specifies the value of the Critical Error in File field.', Comment = '%';
                }
                field("Critical Errors in File"; Rec."Critical Errors in File")
                {
                    ToolTip = 'Specifies the value of the Critical Errors in File field.', Comment = '%';
                    BlankZero = true;
                    Style = Attention;
                }

            }
        }
    }
    actions
    {
        area(Processing)
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
                    NoOrdersinImportMsg: Label 'There is no orders in Import %1, File%2';
                    IntegImport: record "Integration Import";
                begin
                    if not IntegImport.Get(Rec."Import No.") then
                        exit;
                    case IntegImport."Integration Type" of
                        IntegImport."Integration Type"::Sales:
                            begin
                                Clear(SalesIntHeader);
                                SalesIntHeader.SetRange("Import No.", Rec."Import No.");
                                SalesIntHeader.SetRange("File No.", Rec."File No.");
                                if SalesIntHeader.FindSet(false) then
                                    Page.Run(0, SalesIntHeader)
                                else
                                    Message(NoOrdersinImportMsg, Rec."Import No.", Rec."File No.");
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

    }
}
