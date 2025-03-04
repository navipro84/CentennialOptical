pageextension 50200 "Sales Order Ext 1" extends "Sales Order"
{
    actions
    {
        addlast("&Order Confirmation")
        {

            action(OlegPrint)
            {
                ApplicationArea = All;
                Caption = 'Oleg Test Print2';
                Image = "CreateYear";
                trigger OnAction()
                var
                    PrintSmth: Codeunit "Print Something";
                begin
                    PrintSmth.PrintSalesOrder(Rec);
                end;
            }



        }
    }
}
