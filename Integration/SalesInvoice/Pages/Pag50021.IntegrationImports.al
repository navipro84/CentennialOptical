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
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                }
                field("Integration Type"; Rec."Integration Type")
                {
                    ToolTip = 'Specifies the value of the Integration Type field.', Comment = '%';
                }
                field("Files Processed"; Rec."Files Processed")
                {
                    ToolTip = 'Specifies the value of the Files Processed field.', Comment = '%';
                }
                field("Processed Date Time"; Rec."Processed Date Time")
                {
                    ToolTip = 'Specifies the value of the Processed Date Time field.', Comment = '%';
                }
                field("Records Imported"; Rec."Records Imported")
                {
                    ToolTip = 'Specifies the value of the Records Imported field.', Comment = '%';
                }
                field("Errors in Import"; Rec."Errors in Import")
                {
                    ToolTip = 'Specifies the value of the Errors in Import field.', Comment = '%';
                }
                field("Critical Error in Import"; Rec."Critical Error in Import")
                {
                    ToolTip = 'Specifies the value of the Critical Error in Import field.', Comment = '%';
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
}
