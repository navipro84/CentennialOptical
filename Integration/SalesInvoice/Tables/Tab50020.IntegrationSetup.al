table 50020 "Integration Setup"
{
    Caption = 'Integration Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Integration Type"; Enum "Integration Type")
        {
            Caption = 'Integration Type';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Storage Account Name"; Text[50])
        {
            Caption = 'Storage Account Name';
        }
        field(40; "Container Name"; Text[50])
        {
            Caption = 'Container Name';
        }
        field(50; "Email Errors"; Boolean)
        {
            Caption = 'Email Errors';
        }
        field(60; "Error Email Address"; Text[100])
        {
            Caption = 'Error Email Address';
        }
        field(70; "Post Orders"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "State Tax G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(90; "County Tax G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(100; "City Tax G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(110; "School Tax G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(120; "Other Tax G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(130; "Item Dimension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension";
        }
        field(140; "Income G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(150; "Inventory G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(160; "COGS G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }


    keys
    {
        key(PK; "Integration Type")
        {
            Clustered = true;
        }
    }
    var

    procedure SetSecret(pSecret: Text)
    begin
        IsolatedStorage.Set('Int-' + Format(Rec."Integration Type"), pSecret, DataScope::Company);
    end;

    [NonDebuggable]
    local procedure GetSecret(): Text
    var
        rSecret: Text;

    begin
        if IsolatedStorage.Get('Int-' + Format(Rec."Integration Type"), DataScope::Company, rSecret) then
            exit(rSecret);
    end;

    [NonDebuggable]
    procedure GetSecretValue(): SecretText

    begin
        exit(GetSecret());
    end;
}
