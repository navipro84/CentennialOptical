page 50160 "Integration File Loads"
{
    ApplicationArea = All;
    Caption = 'Integration File Loads';
    PageType = List;
    SourceTable = "Integration File Load";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File No."; Rec."File No.")
                {
                    ToolTip = 'Specifies the value of the Load No. field.', Comment = '%';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field("Integration Type"; Rec."Integration Type")
                {
                    ToolTip = 'Specifies the value of the Integration Type field.', Comment = '%';
                }
                field("No. of Orders"; Rec."No. of Orders")
                {
                    ToolTip = 'Specifies the value of the No. of Orders field.', Comment = '%';
                }
                field("No. of Orders with Errors"; Rec."No. of Orders with Errors")
                {
                    ToolTip = 'Specifies the value of the No. of Orderswith Errors field.', Comment = '%';
                    Style = Attention;
                }
                field("No of Lines"; Rec."No of Lines")
                {
                    ToolTip = 'Specifies the value of the No of Lines field.', Comment = '%';
                }
                field("Critical Error in File"; Rec."Critical Error in File")
                {
                    ToolTip = 'Specifies the value of the Critical Error in File field.', Comment = '%';
                }
                field("Loaded Date Time"; Rec."Loaded Date Time")
                {
                    ToolTip = 'Specifies the value of the Loaded Date Time field.', Comment = '%';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadRawData)
            {
                ApplicationArea = All;
                Caption = 'Load Data from Raw';
                Image = Import;

                trigger OnAction();
                var

                    RawToBuffer: Codeunit "Raw to Buffer Transfer";
                begin
                    RawToBuffer.MoveData();
                end;
            }
            action(ShowRaw)
            {
                ApplicationArea = All;
                Caption = 'Show Raw Data';
                RunObject = Page "Raw Sales Integration Lines";
                Image = LineDescription;
            }
        }
    }
}
