table 50151 "Sales Integration Line"
{
    Caption = 'Sales Integration Line';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "File No."; Code[20])
        {
            Caption = 'File No.';

        }
        field(20; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(40; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(50; "Item Quantity"; Decimal)
        {
            Caption = 'Item Quantity';
        }
        field(52; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(60; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
        field(70; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
        }
        field(80; "Sales Document Line No."; Integer)
        {
            Caption = 'Sales Document Line No.';
        }
        field(90; "Error In Line"; Boolean)
        {
            Caption = 'Error In Line';
        }
        field(100; "Critical Error In Line"; Boolean)
        {
            Caption = 'Critical Error In Line';
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
        key(PK; "File No.", "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
