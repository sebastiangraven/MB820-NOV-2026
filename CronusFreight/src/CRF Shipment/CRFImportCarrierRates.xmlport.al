xmlport 50100 "CRF Import Carrier Rates"
{
    Caption = 'Import Carrier Rates';
    Direction = Import;
    Format = Xml;

    schema
    {
        textelement(CarrierRates)
        {
            textattribute(carrier) { }
            tableelement(Rate; "CRF Carrier Rate")
            {
                fieldelement(WeightLimit; Rate."Weight Limit") { }
                fieldelement(Price; Rate.Price) { }

                trigger OnBeforeInsertRecord()
                begin
                    Rate.Carrier := CarrierFromName(carrier);
                end;
            }
        }
    }

    local procedure CarrierFromName(CarrierName: Text): Enum "CRF Carrier"
    var
        CRFCarrier: Enum "CRF Carrier";
        Index: Integer;
        UnknownCarrierErr: Label 'The rate file is for carrier %1, which isn''t a known carrier.', Comment = '%1 = carrier name';
    begin
        Index := CRFCarrier.Names().IndexOf(CarrierName);
        if Index = 0 then
            Error(UnknownCarrierErr, CarrierName);
        exit(Enum::"CRF Carrier".FromInteger(CRFCarrier.Ordinals().Get(Index)));
    end;
}