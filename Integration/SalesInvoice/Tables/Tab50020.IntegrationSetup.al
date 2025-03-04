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
