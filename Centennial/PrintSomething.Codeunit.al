codeunit 50200 "Print Something"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ReportManagement", 'OnAfterGetPrinterName', '', true, true)]
    local procedure OverridePrinter(ReportID: Integer; var PrinterName: Text)
    var
        PrinterOverride: Record "Printer Override";
    begin
        message('Default printer setting for user %1 is %2\Printer was forced as %3', UserID, PrinterName, 'EPSON - Home Office (DESKTOP-D3L50MP)');
        if PrinterOverride.Get(UserID, ReportID) then
            PrinterName := PrinterOverride."Printer Name"
        else
            PrinterName := 'EPSON - Home Office (DESKTOP-D3L50MP)';
        //PrinterName := PrinterOverride."Printer Name";

    end;

    procedure PrintSalesOrder(pSalesHeader: Record "Sales Header");
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, pSalesHeader."No.");
        SalesHeader.SetRecFilter();
        Report.Run(1305, false, false, SalesHeader);
    end;

}
