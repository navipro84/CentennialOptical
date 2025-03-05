table 50150 "Sales Integration Header"
{
    Caption = 'Sales Integration Header';
    DataClassification = CustomerContent;
    LookupPageId = "Sales Integration Orders";
    DrillDownPageId = "Sales Integration Orders";

    fields
    {
        field(5; "Import No"; Integer)
        {
            Caption = 'File No.';
        }
        field(10; "File No."; Integer)
        {
            Caption = 'File No.';
        }
        field(20; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(30; "File Name "; Code[50])
        {
            Caption = 'File Name ';
        }

        field(40; "Document Type"; Enum "Sales Integ. Document Type")
        {
            Caption = 'Document Type';
        }
        field(50; "External Document No."; Code[40])
        {
            Caption = 'External Document No.';
        }
        field(60; "Bill-To Customer No."; Code[20])
        {
            Caption = 'Bill-To Customer No.';
        }
        field(70; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
        }
        field(80; "External Customer Name"; Text[50])
        {
            Caption = 'External Customer Name';
        }
        field(90; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(100; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(110; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }
        field(130; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(140; "Customer PO"; Text[30])
        {
            Caption = 'Customer PO';
        }
        field(150; "Original Order No."; Code[30])
        {
            Caption = 'Original Order No.';
        }
        field(160; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
        }
        field(170; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
        }
        field(180; "Tax Code"; Code[20])
        {
            Caption = 'Tax Code';
        }
        field(190; "Misc Charge 1 Code"; Code[20])
        {
            Caption = 'Misc Charge 1 Code';
        }
        field(210; "Misc Charge 2 Code"; Code[20])
        {
            Caption = 'Misc Charge 1 Code';
        }
        field(220; "Misc Charge 3 Code"; Code[20])
        {
            Caption = 'Misc Charge 3 Code';
        }
        field(230; "Misc Charge 1 Amount"; Decimal)
        {
            Caption = 'Misc Charge 1 Amount';
        }
        field(240; "Misc Charge 2 Amount"; Decimal)
        {
            Caption = 'Misc Charge 1 Amount';
        }
        field(250; "Misc Charge 3 Amount"; Decimal)
        {
            Caption = 'Misc Charge 3 Amount';
        }

        field(500; "Imported Date Time"; DateTime)
        {
            Caption = 'File Loaded Date Time';
        }
        field(510; "Order Processed"; Boolean)
        {
            Caption = 'Order Processed';
        }
        field(520; "Order Processed Date Time"; DateTime)
        {
            Caption = 'Order Processed Date Time';
        }
        field(530; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
        field(540; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
        }
        field(550; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
        }
        field(558; "Error In Order"; Boolean)
        {
            Caption = 'Error In Order';
        }

        field(570; "Errors in Order"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Integration Error Line"
                                where("Integration Import No." = field("Import No"),
                                    "Integration File No." = field("File No."),
                                    "Integration Order No." = field("Order No.")));
        }

    }
    keys
    {
        key(PK; "Import No", "File No.", "Order No.")
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
        IntLine.SetRange("Import No.", rec."Import No");
        IntLine.SetRange("File No.", rec."File No.");
        IntLine.SetRange("Order No.", Rec."Order No.");
        IntLine.DeleteAll();

        Clear(lIntErrorLine);
        lIntErrorLine.SetRange("Integration Import No.", rec."Import No");
        lIntErrorLine.SetRange("Integration File No.", rec."File No.");
        lIntErrorLine.SetRange("Integration Order No.", Rec."Order No.");
        lIntErrorLine.DeleteAll;
    end;



}
