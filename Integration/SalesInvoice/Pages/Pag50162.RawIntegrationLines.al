page 50162 "Raw Sales Integration Lines"
{
    ApplicationArea = All;
    Caption = 'Raw Sales Integration Lines';
    PageType = List;
    SourceTable = "Sales Integration Raw";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(FileName; Rec.FileName)
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field(INVOICE_LINE_KEY; Rec.INVOICE_LINE_KEY)
                {
                    ToolTip = 'Specifies the value of the INVOICE_LINE_KEY field.', Comment = '%';
                }

                field(InvoiceNo; Rec.InvoiceNo)
                {
                    ToolTip = 'Specifies the value of the InvoiceNo field.', Comment = '%';
                }
                field(ITEM_NUMBER; Rec.ITEM_NUMBER)
                {
                    ToolTip = 'Specifies the value of the ITEM_NUMBER field.', Comment = '%';
                }
                field(ITEM_DESCRIPTION_1; Rec.ITEM_DESCRIPTION_1)
                {
                    ToolTip = 'Specifies the value of the ITEM_DESCRIPTION_1 field.', Comment = '%';
                }
                field(QTY_SHIPPED; Rec.QTY_SHIPPED)
                {
                    ToolTip = 'Specifies the value of the QTY_SHIPPED field.', Comment = '%';
                }
                field(NET_PRICE_EXTENSION; Rec.NET_PRICE_EXTENSION)
                {
                    ToolTip = 'Specifies the value of the NET_PRICE_EXTENSION field.', Comment = '%';
                }
                field(LOCATION; Rec.LOCATION)
                {
                    ToolTip = 'Specifies the value of the LOCATION field.', Comment = '%';
                }
                field(DATE_SHIPPED; Rec.DATE_SHIPPED)
                {
                    ToolTip = 'Specifies the value of the DATE_SHIPPED field.', Comment = '%';
                }
                field(CUSTOMER_NO; Rec.CUSTOMER_NO)
                {
                    ToolTip = 'Specifies the value of the CUSTOMER_NO field.', Comment = '%';
                }
                field(CUSTOMER_NAME; Rec.CUSTOMER_NAME)
                {
                    ToolTip = 'Specifies the value of the CUSTOMER_NAME field.', Comment = '%';
                }
                field(TOTAL_DOLLARS; Rec.TOTAL_DOLLARS)
                {
                    ToolTip = 'Specifies the value of the TOTAL_DOLLARS field.', Comment = '%';
                }
                field(CUSTOMER_PO; Rec.CUSTOMER_PO)
                {
                    ToolTip = 'Specifies the value of the CUSTOMER_PO field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }
}
