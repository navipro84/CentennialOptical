table 50022 "Integration Import File"
{
    Caption = 'Integration Import File';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(10; "Import No."; Integer)
        {
            Caption = 'Import No.';
            TableRelation = "Integration Import";
            ValidateTableRelation = true;
        }
        field(15; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(20; "File No."; Integer)
        {
            Caption = 'File No.';
        }
        field(30; "File Name"; Text[200])
        {
            Caption = 'File Name';
        }
        field(40; "File Length"; Integer)
        {
            Caption = 'File Length';
        }
        field(50; "Errors in File"; Integer)
        {
            Caption = 'Errors in File';
        }
        field(60; "Critical Error in File"; Boolean)
        {
            Caption = 'Critical Error in File';
        }
        field(62; "Critical Errors in File"; Integer)
        {
            Caption = 'Critical Errors in File';
            FieldClass = FlowField;
            CalcFormula = Count("Integration Error Line" where("Integration Import No." = field("Import No."), "Integration File No." = field("File No."),
                                                                    "Integration Order No." = const('')));
        }
        field(70; "File Lines Imported"; Integer)
        {
            Caption = 'Records Processed';
        }
        field(80; "File Orders Imported"; Integer)
        {
            Caption = 'Records Processed';
        }
    }
    keys
    {
        key(PK; "Import No.", "File No.")
        {
            Clustered = true;
        }
        key(Key2; "Company Name", "File Name")
        {

        }
    }
}
