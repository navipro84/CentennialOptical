page 50164 "Integration Error Lines"
{
    ApplicationArea = All;
    Caption = 'Integration Error Lines';
    PageType = List;
    SourceTable = "Integration Error Line";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Integration Type"; Rec."Integration Type")
                {
                    ToolTip = 'Specifies the value of the Integration Type field.', Comment = '%';
                }
                field("Integration File No."; Rec."Integration File No.")
                {
                    ToolTip = 'Specifies the value of the Integration File No. field.', Comment = '%';
                }
                field("Integration Order No."; Rec."Integration Order No.")
                {
                    ToolTip = 'Specifies the value of the Integration Order No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Error Line No."; Rec."Error Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                }
                field("Critical Error"; Rec."Critical Error")
                {
                    ToolTip = 'Specifies the value of the Critical Error field.', Comment = '%';
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the value of the Created DateTime field.', Comment = '%';
                }
            }
        }
    }
}
