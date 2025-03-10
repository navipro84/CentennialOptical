page 50202 "ABS Container Items"
{
    ApplicationArea = All;
    Caption = 'ABS Container Items';
    PageType = List;
    SourceTable = "ABS Container Content";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Blob Type"; Rec."Blob Type")
                {
                    ToolTip = 'Specifies the value of the BlobType field.', Comment = '%';
                }
                field("Content Length"; Rec."Content Length")
                {
                    ToolTip = 'Specifies the value of the Content-Length field.', Comment = '%';
                }
                field("Content Type"; Rec."Content Type")
                {
                    ToolTip = 'Specifies the value of the Content-Type field.', Comment = '%';
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ToolTip = 'Specifies the value of the Creation-Time field.', Comment = '%';
                }

                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.', Comment = '%';
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ToolTip = 'Specifies the value of the Last-Modified field.', Comment = '%';
                }
                field(Level; Rec.Level)
                {
                    ToolTip = 'Specifies the value of the Level field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Parent Directory"; Rec."Parent Directory")
                {
                    ToolTip = 'Specifies the value of the Parent Directory field.', Comment = '%';
                }
                field("Resource Type"; Rec."Resource Type")
                {
                    ToolTip = 'Specifies the value of the ResourceType field.', Comment = '%';
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
                field(URI; Rec.URI)
                {
                    ToolTip = 'Specifies the value of the URI field.', Comment = '%';
                }
                field("XML Value"; Rec."XML Value")
                {
                    ToolTip = 'Specifies the value of the XML Value field.', Comment = '%';
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("List Blobs on Azure")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'List Blobs on Azure';
                Image = OrderList;

                trigger OnAction()
                begin
                    ImportFromAzure();
                end;
            }

            action("Import Data from Azure")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Data from Azure';
                Image = Import;

                trigger OnAction()
                begin
                    ImportFromADS.AuthorizeAzure(IntType::Sales);
                    ImportFromADS.ImportFromAzure(IntType::Sales);
                end;
            }

        }
    }
    var
        ImportFromADS: Codeunit "Import File from ADS";
        IntType: Enum "Integration Type";

    trigger OnOpenPage()
    begin

    end;

    procedure ImportFromAzure()
    var
        ABSContContent: Record "ABS Container Content";
        ABSBlob: Codeunit "ABS Blob Client";
        ABSContainerClient: Codeunit "ABS Container Client";
        Response: Codeunit "ABS Operation Response";
        StorageServiceAuth: Codeunit "Storage Service Authorization";
        IsSuccess: Boolean;
        InStrm: InStream;
        Authorization: Interface "Storage Service Authorization";
        OutStrm: OutStream;
        ContainerName: Text;
        SharedKey: SecretText;
        StorageAccount: Text;
        LastNo: Integer;
        mesall: Text;
        mes: List of [Text];
        CRLF: Char;
        IntegrationSetup: Record "Integration Setup";
    begin
        If not IntegrationSetup.Get(IntegrationSetup."Integration Type"::Sales) then
            exit;

        ContainerName := IntegrationSetup."Container Name";
        StorageAccount := IntegrationSetup."Storage Account Name";
        SharedKey := IntegrationSetup.GetSecretValue();
        Authorization := StorageServiceAuth.CreateSharedKey(SharedKey);
        ABSBlob.Initialize(StorageAccount, ContainerName, Authorization);
        Response := ABSBlob.ListBlobs(Rec);
        if not Response.IsSuccessful() then
            Message('error: %1', Response.GetError())
        else
            Message('Success');

    end;
}
