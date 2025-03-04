table 50021 "Integration Import"
{
    Caption = 'Integration Import';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(10; "Import No."; Integer)
        {
            Caption = 'Import No.';
        }
        field(20; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(30; "Integration Type"; Enum "Integration Type")
        {
            Caption = 'Integration Type';
        }
        field(40; "Processed Date Time"; DateTime)
        {
            Caption = 'Processed Date Time';
        }
        field(50; "Records Imported"; Integer)
        {
            Caption = 'Records Imported';
        }
        field(60; "Files Processed"; Integer)
        {
            Caption = 'Files Processed';
            FieldClass = FlowField;
            CalcFormula = count("Integration Import File" where("Import No." = field("Import No.")));
        }
        field(70; "Errors in Import"; Integer)
        {
            Caption = 'Errors in Import';
        }
        field(80; "Critical Error in Import"; Integer)
        {
            Caption = 'Critical Error in Import';

        }
    }
    keys
    {
        key(PK; "Import No.")
        {
            Clustered = true;
        }
    }
}
