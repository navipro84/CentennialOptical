page 50020 "Integration Setup"
{
    ApplicationArea = All;
    Caption = 'Integration Setup';
    PageType = List;
    SourceTable = "Integration Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Integration Type"; Rec."Integration Type")
                {
                    ToolTip = 'Specifies the value of the Integration Type field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Container Name"; Rec."Container Name")
                {
                    ToolTip = 'Specifies the value of the Azure Container Name field.', Comment = '%';
                }
                field("Storage Account Name"; Rec."Storage Account Name")
                {
                    ToolTip = 'Specifies the value of the Azure Storage Account Name field.', Comment = '%';
                }

                field(AzureSharedKey; Secret)
                {
                    ExtendedDatatype = Masked;
                    Caption = 'Azure Shared Key';
                    trigger OnValidate()
                    begin
                        Rec.SetSecret(Secret);
                    end;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(TestAzureConnection)
            {
                Caption = 'Test Azure Connection';

                trigger OnAction()
                var
                    ImportFilesFromADS: Codeunit "Import File from ADS";
                    IntType: Enum "Integration Type";
                    lResponse: Text;
                    lSuccess: Boolean;
                begin
                    Clear(ImportFilesFromADS);
                    lResponse := ImportFilesFromADS.AuthorizeAzure(Rec."Integration Type");
                    if lResponse <> '' then begin
                        Message('Connection to Azure Storage Account %1, Container %2 failed.\Error:%3', Rec."Storage Account Name", Rec."Container Name", lResponse);
                        exit;
                    end;
                    lResponse := ImportFilesFromADS.TestAzureConnection(lSuccess);
                    if lSuccess then
                        Message('Connection was successful. \' + lResponse)
                    else
                        Message('Connection to Azure Storage Account %1, Container %2 failed.\Error:%3', Rec."Storage Account Name", Rec."Container Name", lResponse);
                end;
            }
        }
    }

    var
        Secret: Text;

    trigger OnOpenPage()
    begin
        if not (Rec.GetSecretValue.IsEmpty()) then
            Secret := 'secret';
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if not (Rec.GetSecretValue.IsEmpty()) then
            Secret := 'secret';
    end;

    trigger OnAfterGetRecord()
    begin
        if not (Rec.GetSecretValue.IsEmpty()) then
            Secret := 'secret';
    end;
}
