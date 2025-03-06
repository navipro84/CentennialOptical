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
                    StyleExpr = (Rec."Error in Line");
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Style = Attention;
                    StyleExpr = (Rec."Error in Line");
                    visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    ToolTip = 'Specifies the value of the Item Description 2 field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Customer Item No."; Rec."Customer Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }

                field("Quantity Ordered"; Rec."Quantity Ordered")
                {
                    ToolTip = 'Specifies the value of the Item Quantity field.', Comment = '%';
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ToolTip = 'Specifies the value of the Quantity Shipped field.', Comment = '%';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.', Comment = '%';
                }
                field("Line Cost"; Rec."Line Cost")
                {
                    ToolTip = 'Specifies the value of the Line Cost field.', Comment = '%';
                }
                field(Taxable; Rec.Taxable)
                {
                    ToolTip = 'Specifies the value of the Taxable field.', Comment = '%';
                }
                field("State Tax Amount"; Rec."State Tax Amount")
                {
                    ToolTip = 'Specifies the value of the State Tax Amount field.', Comment = '%';
                }

                field("County Tax Amount"; Rec."County Tax Amount")
                {
                    ToolTip = 'Specifies the value of the County Tax Amount field.', Comment = '%';
                }
                field("City Tax Amount"; Rec."City Tax Amount")
                {
                    ToolTip = 'Specifies the value of the CityTax Amount field.', Comment = '%';
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

                field("Errors in Line"; Rec."Errors in Line")
                {
                    ToolTip = 'Specifies the value of the Errors in Line field.', Comment = '%';
                }
            }
        }
    }
}
