table 50160 "Misc Charge"
{
    Caption = 'Misc Charge';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Misc Charge Code"; Code[20])
        {
            Caption = 'Misc Charge Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "G/L Account"; Code[20])
        {
            Caption = 'G/L Account';
            TableRelation = "G/L Account";
            ValidateTableRelation = true;
        }
    }
    keys
    {
        key(PK; "Misc Charge Code")
        {
            Clustered = true;
        }
    }
}
