table 50151 "Sales Integration Line"
{
    Caption = 'Sales Integration Line';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Import No."; Integer)
        {
            Caption = 'File No.';

        }
        field(20; "File No."; Integer)
        {
            Caption = 'File No.';
        }
        field(30; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(52; "Customer Item No."; Code[40])
        {
            Caption = 'Item No.';
        }
        field(55; "Item Description"; Text[50])
        {
            Caption = 'Item Description';
        }
        field(56; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(58; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
        }
        field(60; "Quantity Ordered"; Decimal)
        {
            Caption = 'Quantity Ordered';
        }
        field(70; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
        }
        field(80; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(90; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(100; "Line Cost"; Decimal)
        {
            Caption = 'Line Cost';
        }
        field(110; "State Tax Amount"; Decimal)
        {
            Caption = 'State Tax Amount';
        }
        field(120; "County Tax Amount"; Decimal)
        {
            Caption = 'County Tax Amount';
        }
        field(130; "City Tax Amount"; Decimal)
        {
            Caption = 'CityTax Amount';
        }
        field(200; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
        field(210; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
        }
        field(220; "Sales Document Line No."; Integer)
        {
            Caption = 'Sales Document Line No.';
        }
        field(230; "Error In Line"; Boolean)
        {
            Caption = 'Error In Line';
        }

        field(170; "Errors in Line"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Integration Error Line"
                                where("Integration Type" = Const(Sales),
                                    "Integration File No." = field("File No."),
                                    "Integration Order No." = field("Order No."),
                                    "Line No." = field("Line No.")));
        }
    }

    keys
    {
        key(PK; "Import No.", "File No.", "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
