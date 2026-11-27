table 50100 "CRF Freight Setup"
{
    Caption = 'Cronus Freight Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Default Carrier"; Enum "CRF Carrier")
        {
            Caption = 'Default Carrier';
            DataClassification = CustomerContent;
        }
        field(3; "API Base URL"; Text[250])
        {
            Caption = 'API Base URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(4; "Shipment Nos."; Code[20])
        {
            Caption = 'Shipment Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Stores the carrier API key in isolated storage (encrypted, per company). An empty key deletes the stored one.
    /// </summary>
    procedure SetApiKey(NewApiKey: SecretText)
    begin
        if NewApiKey.IsEmpty() then begin
            if IsolatedStorage.Contains(ApiKeyStorageKeyTok, DataScope::Company) then
                IsolatedStorage.Delete(ApiKeyStorageKeyTok, DataScope::Company);
            exit;
        end;
        IsolatedStorage.SetEncrypted(ApiKeyStorageKeyTok, NewApiKey, DataScope::Company);
    end;

    /// <summary>
    /// Returns the stored API key as a SecretText, or an empty one if no key is stored.
    /// </summary>
    procedure GetApiKey() ApiKey: SecretText
    begin
        if IsolatedStorage.Get(ApiKeyStorageKeyTok, DataScope::Company, ApiKey) then
            exit(ApiKey);
    end;

    /// <summary>
    /// Tells whether an API key is stored, without reading it.
    /// </summary>
    procedure HasApiKey(): Boolean
    begin
        exit(IsolatedStorage.Contains(ApiKeyStorageKeyTok, DataScope::Company));
    end;

    var
        ApiKeyStorageKeyTok: Label 'CRF-CarrierApiKey', Locked = true;
}