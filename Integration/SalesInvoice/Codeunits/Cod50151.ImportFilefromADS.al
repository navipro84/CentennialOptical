codeunit 50151 "Import File from ADS"
{
    trigger OnRun()
    begin

    end;

    var
        CannotListContainersErr: Label 'Cannot list containers: %1';
        FileIsBlankErr: Label 'File is blank';
        CannotDeleteErr: Label 'Cannot delete %1';
        CannotCopyErr: Label 'Cannot copy %1 to %2';
        IntegHasNoSetupErr: Label 'Integration Type %1 has no setup';
        Authorization: Interface "Storage Service Authorization";
        FileAlreadyProcessedErr: Label 'File was already processed in Import %1';
        ABSBlob: Codeunit "ABS Blob Client";
        CR: Char;

    procedure ImportFromAzure(pIntType: Enum "Integration Type"): Text
    var
        lResponse: Codeunit "ABS Operation Response";
        lInStrm: InStream;
        lCSVBuffer: Record "CSV Buffer" temporary;
        lSuccess: Boolean;
        lProcessedFolder: Text[50];
        lErrorsFolder: Text[50];
        lLogFolder: text[50];
        lABSContContent: Record "ABS Container Content";
        lErrorText: List of [Text];
        lIntegrationImport: Record "Integration Import";
        lIntegrationImportFile: Record "Integration Import File";
        lNewLineNo: Integer;
        lNoOfFiles: Integer;
        lFileErrorCounter: Integer;
        lCriticalErrorinFile: Boolean;
        lCriticalErrorinImport: Integer;
        lTotalRecordCounter: Integer;
        lFileLineCounter: Integer;
        lFileOrderCounter: Integer;
        lTotalErrorsCounter: Integer;
        lIntegrationImportFile2: Record "Integration Import File";
        lSingleError: Text;
        lBigErrorText: Text;
        lImportSalesData: Codeunit "Import Sales Data";
        lIntegErrorLine: Record "Integration Error Line";
        i: Integer;
        lTotalOrderCounter: Integer;
    begin
        lProcessedFolder := 'processed';
        lErrorsFolder := 'errors';
        lLogFolder := 'errorlogs';
        lResponse := ABSBlob.ListBlobs(lABSContContent);
        if not lResponse.IsSuccessful() then
            error(CannotListContainersErr, lResponse.GetError());

        Clear(lIntegrationImport);
        if lIntegrationImport.FindLast then
            lNewLineNo := lIntegrationImport."Import No." + 1
        else
            lNewLineNo := 1;

        Clear(lIntegrationImport);
        lIntegrationImport."Import No." := lNewLineNo;
        lIntegrationImport."Company Name" := CompanyName;
        lIntegrationImport."Integration Type" := pIntType;
        lIntegrationImport.Insert();
        lNoOfFiles := 0;

        Clear(lIntegrationImportFile2);
        lIntegrationImportFile2.SetCurrentKey("Company Name", "File Name");
        lIntegrationImportFile2.SetRange("Company Name", CompanyName);


        lABSContContent.SetRange("Full Name");
        lABSContContent.SetFilter("Content Type", '<>%1', 'Directory');
        lABSContContent.SetRange(Level, 0);
        if lABSContContent.FindSet then begin
            repeat //read each file
                lSuccess := true;
                Clear(lErrorText);
                lNoOfFiles += 1;
                lFileErrorCounter := 0;
                lCriticalErrorinFile := false;
                lFileLineCounter := 0;
                lFileOrderCounter := 0;

                //Check is file with this name was already processed
                lIntegrationImportFile2.SetRange("File Name", lABSContContent.Name);
                if lIntegrationImportFile2.FindFirst() then begin
                    lSuccess := false;
                    lErrorText.Add(StrSubstNo(FileAlreadyProcessedErr, lIntegrationImportFile2."Import No."));
                end;

                Clear(lIntegrationImportFile);
                lIntegrationImportFile."Import No." := lIntegrationImport."Import No.";
                lIntegrationImportFile."Company Name" := lIntegrationImport."Company Name";
                lIntegrationImportFile."File No. " := lNoOfFiles;
                lIntegrationImportFile."File Name" := lABSContContent.Name;
                lIntegrationImportFile."File Length" := lABSContContent."Content Length";
                lIntegrationImportFile.Insert;

                if lSuccess then begin
                    Clear(lInStrm);
                    lResponse := ABSBlob.GetBlobAsStream(lABSContContent.Name, lInStrm);
                    if lResponse.IsSuccessful() then begin
                        Clear(lCSVBuffer);
                        lCSVBuffer.DeleteAll();
                        lCSVBuffer.LoadDataFromStream(lInStrm, ',');

                        if lCSVBuffer.GetNumberOfLines() > 0 then begin
                            case pIntType of
                                pIntType::Sales:
                                    begin
                                        lImportSalesData.StartImport(lCSVBuffer, lIntegrationImportFile, lFileLineCounter, lFileErrorCounter, lErrorText, lFileOrderCounter);
                                    end;
                            end;
                        end else begin
                            lSuccess := false;
                            lErrorText.Add(FileIsBlankErr);
                        end;


                    end else begin
                        lSuccess := false;
                        lErrorText.Add(lResponse.GetError());
                    end;
                end;

                if lErrorText.Count > 0 then
                    lSuccess := false;

                if lSuccess then begin //move file to Processed subfolder
                    lResponse := ABSBlob.CopyBlob(lProcessedFolder + '/' + lABSContContent.Name, lABSContContent.Name);
                    if lResponse.IsSuccessful() then begin
                        lResponse := ABSBlob.DeleteBlob(lABSContContent.Name);
                        if lResponse.IsSuccessful() then begin
                            Commit;
                        end else begin
                            Error(CannotDeleteErr, lABSContContent.Name); //Trigger runtime error to rollback the changes
                        end;
                    end else begin
                        Error(CannotCopyErr, lABSContContent.Name, lProcessedFolder + '/' + lABSContContent.Name); //Trigger runtime error to rollback the changes
                    end;
                end else begin //move file to Errors subfolder
                    lResponse := ABSBlob.CopyBlob(lErrorsFolder + '/' + lABSContContent.Name, lABSContContent.Name);
                    if not lResponse.IsSuccessful() then
                        Error(CannotCopyErr, lABSContContent.Name, lProcessedFolder + '/' + lABSContContent.Name); //Trigger runtime error to rollback the changes
                    //Create a log file with error description
                    lBigErrorText := '';
                    CR := 13; //Carriage Return
                    i := 0;
                    foreach lSingleError in lErrorText do begin
                        i += 1;
                        lBigErrorText += lSingleError + CR;
                        Clear(lIntegErrorLine);
                        lIntegErrorLine."Integration Import No." := lIntegrationImport."Import No.";
                        lIntegErrorLine."Integration File No." := lIntegrationImportFile."File No. ";
                        lIntegErrorLine."Integration Order No." := ''; //Order was not created, it is a critical error
                        lIntegErrorLine."Line No." := 0;
                        lIntegErrorLine."Error Line No." := i;
                        lIntegErrorLine."Integration Type" := lIntegrationImport."Integration Type";
                        lIntegErrorLine."Error Description" := lSingleError;
                        lIntegErrorLine."Critical Error" := true;
                        lIntegErrorLine."Created DateTime" := CurrentDateTime;
                        lIntegErrorLine.Insert;
                    end;
                    ABSBlob.PutBlobBlockBlobText(lLogFolder + '/' + lABSContContent.Name + '.log', lBigErrorText);
                    lResponse := ABSBlob.DeleteBlob(lABSContContent.Name);
                    if not lResponse.IsSuccessful() then
                        Error(CannotDeleteErr, lABSContContent.Name); //Trigger runtime error to rollback the changes
                    lCriticalErrorinFile := true;
                end;

                lIntegrationImportFile."Errors in File" := lFileErrorCounter;
                lIntegrationImportFile."Critical Error in File" := lCriticalErrorinFile;
                lIntegrationImportFile."File Lines Imported" := lFileLineCounter;
                lIntegrationImportFile."File Orders Imported" := lFileOrderCounter;

                lIntegrationImportFile.Modify;

                if lIntegrationImportFile."Critical Error in File" then
                    lCriticalErrorinImport += 1;

                Commit; //Commit after every file import
            until lABSContContent.Next = 0;
        end;
        lIntegrationImport."Files in Import" := lNoOfFiles > 0;
        lIntegrationImport."Processed Date Time" := CurrentDateTime;
        lIntegrationImport."Files Processed" := lNoOfFiles;
        lIntegrationImport."Errors in Import" := lTotalErrorsCounter;

        lIntegrationImport.Modify;
    end;

    procedure TestAzureConnection(var pSuccess: Boolean): Text
    var
        lResponse: Codeunit "ABS Operation Response";
        lABSContContent: Record "ABS Container Content";
        lErrorText: Text;
        NewLineNo: Integer;
    begin
        lResponse := ABSBlob.ListBlobs(lABSContContent);
        if not lResponse.IsSuccessful() then begin
            pSuccess := false;
            exit(StrSubstNo(CannotListContainersErr, lResponse.GetError()));
        end;

        if lABSContContent.FindSet then begin
            pSuccess := true;
            exit(StrSubstNo('BLOBs found: %1.', lABSContContent.Count));
        end else begin
            pSuccess := true;
            exit(StrSubstNo('No BLOBS found.'));
        end;
    end;


    procedure AuthorizeAzure(pIntType: Enum "Integration Type"): Text
    var
        lStorageServiceAuth: Codeunit "Storage Service Authorization";
        IsSuccess: Boolean;
        lContainerName: Text;
        lSharedKey: SecretText;
        lStorageAccount: Text;
        lIntegrationSetup: Record "Integration Setup";
    begin
        If not lIntegrationSetup.Get(pIntType) then
            exit(StrSubstNo(IntegHasNoSetupErr, pIntType));

        lContainerName := lIntegrationSetup."Container Name";
        lStorageAccount := lIntegrationSetup."Storage Account Name";
        lSharedKey := lIntegrationSetup.GetSecretValue();
        Authorization := lStorageServiceAuth.CreateSharedKey(lSharedKey);
        ABSBlob.Initialize(lStorageAccount, lContainerName, Authorization);
    end;
}

