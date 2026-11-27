page 50100 "CRF Freight Setup"
{
    Caption = 'Cronus Freight Setup';
    PageType = Card;
    SourceTable = "CRF Freight Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    AdditionalSearchTerms = 'carrier, shipping, freight, shipment';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Default Carrier"; Rec."Default Carrier")
                {
                    ToolTip = 'Specifies the carrier that new shipments get when the customer has no default carrier of its own.';
                }
                field("API Base URL"; Rec."API Base URL")
                {
                    ToolTip = 'Specifies the base address of the carrier service that the extension calls.';
                }
                field(ApiKey; ApiKeyText)
                {
                    Caption = 'API Key';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the key that the carrier service gave Cronus. The key is stored in isolated storage, not in the setup table. Clear the field to delete the key.';

                    trigger OnValidate()
                    begin
                        SaveApiKey();
                        ShowApiKeyPlaceholder();
                    end;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Shipment Nos."; Rec."Shipment Nos.")
                {
                    ToolTip = 'Specifies the number series that is used to number new shipments.';
                }
            }
        }
    }

    var
        ApiKeyText: Text;

    trigger OnAfterGetRecord()
    begin
        ShowApiKeyPlaceholder();
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    local procedure ShowApiKeyPlaceholder()
    begin
        // The stored key is never loaded into the page, only a placeholder that shows that one exists
        if Rec.HasApiKey() then
            ApiKeyText := ApiKeyPlaceholderTxt
        else
            ApiKeyText := '';
    end;

    [NonDebuggable]
    local procedure SaveApiKey()
    var
        NewApiKey: SecretText;
    begin
        // The placeholder means the user did not type a new key
        if ApiKeyText = ApiKeyPlaceholderTxt then
            exit;
        NewApiKey := ApiKeyText;
        Rec.SetApiKey(NewApiKey);
    end;

    var
        ApiKeyPlaceholderTxt: Label '********', Locked = true;
}