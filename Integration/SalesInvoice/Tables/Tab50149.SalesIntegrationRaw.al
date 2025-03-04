table 50149 "Sales Integration Raw"
{
    Caption = 'Sales Integration Raw';
    DataClassification = CustomerContent;

    fields
    {
        field(5; INVOICE_LINE_KEY; Text[30])
        {
            Caption = 'INVOICE_LINE_KEY';
        }
        field(8; FileName; Text[50])
        {
            Caption = 'File Name';
        }
        field(10; InvoiceNo; Text[30])
        {
            Caption = 'InvoiceNo';
        }
        field(20; ITEM_NUMBER; Text[30])
        {
            Caption = 'ITEM_NUMBER';
        }
        field(30; ITEM_DESCRIPTION_1; Text[100])
        {
            Caption = 'ITEM_DESCRIPTION_1';
        }
        field(40; QTY_SHIPPED; Text[10])
        {
            Caption = 'QTY_SHIPPED';
        }
        field(50; NET_PRICE_EXTENSION; Text[10])
        {
            Caption = 'NET_PRICE_EXTENSION';
        }
        field(60; LOCATION; Text[20])
        {
            Caption = 'LOCATION';
        }
        field(70; DATE_SHIPPED; Text[20])
        {
            Caption = 'DATE_SHIPPED';
        }
        field(80; CUSTOMER_NO; Text[20])
        {
            Caption = 'CUSTOMER_NO';
        }
        field(90; CUSTOMER_NAME; Text[100])
        {
            Caption = 'CUSTOMER_NAME';
        }
        field(100; TOTAL_DOLLARS; Text[10])
        {
            Caption = 'TOTAL_DOLLARS';
        }
        field(110; CUSTOMER_PO; Text[50])
        {
            Caption = 'CUSTOMER_PO';
        }
    }
    keys
    {
        key(PK; INVOICE_LINE_KEY)
        {
            Clustered = true;
        }
    }
}
