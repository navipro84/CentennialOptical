page 50170 "Misc Charges"
{
    ApplicationArea = All;
    Caption = 'Misc Item';
    PageType = List;
    SourceTable = "Misc Charge";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Misc Charge Code"; Rec."Misc Charge Code")
                {
                    ToolTip = 'Specifies the value of the Misc Code field.', Comment = '%';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
