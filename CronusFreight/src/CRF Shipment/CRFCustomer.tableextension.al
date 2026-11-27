tableextension 50100 "CRF Customer" extends Customer
{
    fields
    {
        field(50100; "CRF Default Carrier"; Enum "CRF Carrier")
        {
            Caption = 'Default Carrier';
            DataClassification = CustomerContent;
        }
    }
}