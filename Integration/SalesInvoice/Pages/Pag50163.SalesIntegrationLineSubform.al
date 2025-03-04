page 50163 "Sales Integration Line Subform"
{
    ApplicationArea = All;
    Caption = 'Sales Integration Line Subform';
    PageType = ListPart;
    SourceTable = "Sales Integration Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File No."; Rec."File No.")
                {
                    ToolTip = 'Specifies the value of the File No. field.', Comment = '%';
                    Visible = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Error in Line" or Rec."Critical Error In Line");
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Error in Line" or Rec."Critical Error In Line");
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Quantity"; Rec."Item Quantity")
                {
                    ToolTip = 'Specifies the value of the Item Quantity field.', Comment = '%';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ToolTip = 'Specifies the value of the Sales Document Type field.', Comment = '%';
                    Visible = false;
                }
                field("Sales Document No."; Rec."Sales Document No.")
                {
                    ToolTip = 'Specifies the value of the Sales Document No. field.', Comment = '%';
                    Visible = false;
                }
                field("Sales Document Line No."; Rec."Sales Document Line No.")
                {
                    ToolTip = 'Specifies the value of the Sales Document Line No. field.', Comment = '%';
                    Visible = false;
                }
                field("Error In Line"; Rec."Error In Line")
                {
                    ToolTip = 'Specifies the value of the Error In Order field.', Comment = '%';
                }
                field("Critical Error In Line"; Rec."Critical Error In Line")
                {
                    ToolTip = 'Specifies the value of the Critical Error In Order field.', Comment = '%';
                }
                field("Errors in Line"; Rec."Errors in Line")
                {
                    ToolTip = 'Specifies the value of the Errors in Line field.', Comment = '%';
                }
            }
        }
    }
}
