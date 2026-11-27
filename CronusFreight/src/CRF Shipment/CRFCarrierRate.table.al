table 50103 "CRF Carrier Rate"
{
    Caption = 'Carrier Rate';

    fields
    {
        field(1; Carrier; Enum "CRF Carrier")
        {
            Caption = 'Carrier';
            DataClassification = CustomerContent;
        }
        field(2; "Weight Limit"; Decimal)
        {
            Caption = 'Weight Limit (kg)';
            DataClassification = CustomerContent;
        }
        field(3; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Carrier, "Weight Limit")
        {
            Clustered = true;
        }
    }
}