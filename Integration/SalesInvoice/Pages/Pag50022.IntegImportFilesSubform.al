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
                }
                field("File Length"; Rec."File Length")
                {
                    ToolTip = 'Specifies the value of the File Length field.', Comment = '%';
                }
                field("Error in File"; Rec."Error in File")
                {
                    ToolTip = 'Specifies the value of the Error in File field.', Comment = '%';
                }
                field("Critical Error in File"; Rec."Critical Error in File")
                {
                    ToolTip = 'Specifies the value of the Critical Error in File field.', Comment = '%';
                }
            }
        }
    }
}
