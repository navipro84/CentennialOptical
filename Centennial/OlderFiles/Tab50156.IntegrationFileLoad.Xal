table 50156 "Integration File Load"
{
    Caption = 'Integration File Load';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "File No."; Code[20])
        {
            Caption = 'Load No.';
        }
        field(15; "Integration Type"; Enum "Integration Type")
        {
            Caption = 'Integration Type';
        }
        field(20; "File Name"; Text[100])
        {
            Caption = 'File Name';
        }
        field(30; "No. of Orders"; Integer)
        {
            Caption = 'No. of Orders';
            FieldClass = FlowField;
            CalcFormula = Count("Sales Integration Header"
                            where("File No." = Field("File No.")));
        }
        field(32; "No. of Orders with Errors"; Integer)
        {
            Caption = 'No. of Orderswith Errors';
            FieldClass = FlowField;
            CalcFormula = Count("Sales Integration Header"
                            where("File No." = Field("File No."), "Error In Order" = Const(true)));
        }
        field(40; "No of Lines"; Integer)
        {
            Caption = 'No of Lines';
            FieldClass = FlowField;
            CalcFormula = Count("Sales Integration Line"
                            where("File No." = Field("File No.")));
        }
        field(50; "Critical Error in File"; Boolean)
        {
            Caption = 'Critical Error in File';
        }
        field(60; "Loaded Date Time"; DateTime)
        {
            Caption = 'Loaded Date Time';
        }
    }
    keys
    {
        key(PK; "File No.")
        {
            Clustered = true;
        }
    }
}
