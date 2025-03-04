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
        field(20; "File No. "; Integer)
        {
            Caption = 'File No. ';
        }
        field(30; "File Name"; Text[200])
        {
            Caption = 'File Name';
        }
        field(40; "File Length"; Integer)
        {
            Caption = 'File Length';
        }
        field(50; "Error in File"; Integer)
        {
            Caption = 'Error in File';
        }
        field(60; "Critical Error in File"; Boolean)
        {
            Caption = 'Critical Error in File';
        }
        field(70; "Records Processed"; Integer)
        {
            Caption = 'Records Processed';
        }
    }
    keys
    {
        key(PK; "Import No.", "File No. ")
        {
            Clustered = true;
        }
    }
}
