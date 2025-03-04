table 50152 "Integration Error Line"
{
    Caption = 'Integration Error Line';
    DataClassification = CustomerContent;
    LookupPageId = "Integration Error Lines";
    DrillDownPageId = "Integration Error Lines";

    fields
    {
        field(10; "Integration Type"; Enum "Integration Type")
        {
            Caption = 'Integration Type';
        }
        field(20; "Integration File No."; Code[20])
        {
            Caption = 'Integration File No.';
        }
        field(30; "Integration Order No."; Code[20])
        {
            Caption = 'Integration Order No.';
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        Field(45; "Error Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Error Description"; Text[200])
        {
            Caption = 'Error Description';
        }
        field(60; "Critical Error"; Boolean)
        {
            Caption = 'Critical Error';
        }
        field(70; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
        }

    }
    keys
    {
        key(PK; "Integration Type", "Integration File No.", "Integration Order No.", "Line No.", "Error Line No.")
        {
            Clustered = true;
        }
    }
}
