table 50200 "Printer Override"
{
    Caption = 'Printer Override';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(2; "Report ID"; Integer)
        {
            Caption = 'Report ID';
        }
        field(3; "Printer Name"; Text[250])
        {
            Caption = 'Printer Name';
        }
    }
    keys
    {
        key(PK; "User ID", "Report ID")
        {
            Clustered = true;
        }
    }
}
