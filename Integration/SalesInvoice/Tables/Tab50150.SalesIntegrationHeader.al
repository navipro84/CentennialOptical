table 50150 "Sales Integration Header"
{
    Caption = 'Sales Integration Header';
    DataClassification = CustomerContent;
    LookupPageId = "Sales Integration Orders";
    DrillDownPageId = "Sales Integration Orders";

    fields
    {
        field(10; "File No."; Code[20])
        {
            Caption = 'File No.';
        }
        field(20; "File Name "; Code[50])
        {
            Caption = 'File Name ';
        }
        field(30; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }

        field(38; "Int. Invoice No."; Code[40])
        {
            Caption = 'Int. Invoice No.';
        }
        field(40; "Bill-To Customer No."; Code[20])
        {
            Caption = 'Bill-To Customer No.';
        }
        field(50; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
        }
        field(52; "Int. Customer Name"; Text[50])
        {
            Caption = 'Int. Customer Name';
        }
        field(60; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(70; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(80; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(90; "Customer PO"; Text[30])
        {
            Caption = 'Customer PO';
        }
        field(100; "File Loaded Date Time"; DateTime)
        {
            Caption = 'File Loaded Date Time';
        }
        field(110; "Order Processed"; Boolean)
        {
            Caption = 'Order Processed';
        }
        field(120; "Order Processed Date Time"; DateTime)
        {
            Caption = 'Order Processed Date Time';
        }
        field(130; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
        field(140; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
        }
        field(150; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
        }
        field(158; "Error In Order"; Boolean)
        {
            Caption = 'Error In Order';
        }
        field(160; "Critical Error In Order"; Boolean)
        {
            Caption = 'Critical Error In Order';
        }
        field(170; "Errors in Order"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Integration Error Line"
                                where("Integration Type" = Const(Sales),
                                    "Integration File No." = field("File No."),
                                    "Integration Order No." = field("Order No.")));
        }

    }
    keys
    {
        key(PK; "File No.", "Order No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        IntLine: Record "Sales Integration Line";
        lIntErrorLine: Record "Integration Error Line";

    begin
        Clear(IntLine);
        IntLine.SetRange("File No.", rec."File No.");
        IntLine.SetRange("Order No.", Rec."Order No.");
        IntLine.DeleteAll();

        Clear(lIntErrorLine);
        lIntErrorLine.SetRange("Integration File No.", rec."File No.");
        lIntErrorLine.SetRange("Integration Order No.", Rec."Order No.");
        lIntErrorLine.DeleteAll;
    end;



}
