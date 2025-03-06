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
        field(50; "File Lines Imported"; Integer)
        {
            Caption = 'File Lines Imported';
            FieldClass = FlowField;
            CalcFormula = Sum("Integration Import File"."File Lines Imported" where("Import No." = field("Import No.")));
        }
        field(52; "File Orders Imported"; Integer)
        {
            Caption = 'File Lines Imported';
            FieldClass = FlowField;
            CalcFormula = Sum("Integration Import File"."File Orders Imported" where("Import No." = field("Import No.")));
        }
        field(60; "Files Processed"; Integer)
        {
            Caption = 'Files Processed';
            FieldClass = FlowField;
            CalcFormula = count("Integration Import File" where("Import No." = field("Import No.")));
        }
        field(62; "Files in Import"; Boolean)
        {
            Caption = 'Files Processed';

        }
        field(70; "Errors in Import"; Integer)
        {
            Caption = 'Errors in Import';
        }
        field(80; "Critical Error in Import"; Boolean)
        {
            Caption = 'Critical Errors in Import';
            FieldClass = FlowField;
            CalcFormula = Exist("Integration Import File" where("Import No." = field("Import No."), "Critical Error in File" = const(true)));
        }
    }
    keys
    {
        key(PK; "Import No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        IntegrationImpFile: Record "Integration Import File";
        IntegrationErrorLine: Record "Integration Error Line";
    begin
        IntegrationImpFile.SetRange("Import No.", Rec."Import No.");
        IntegrationImpFile.DeleteAll;
        IntegrationErrorLine.SetRange("Integration Import No.", Rec."Import No.");
        IntegrationErrorLine.DeleteAll();

    end;
}
