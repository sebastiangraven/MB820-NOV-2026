codeunit 50102 "CRF Carrier B" implements "CRF ICarrier"
{
    Access = Internal;

    procedure GetRate(ShipmentHeader: Record "CRF Shipment Header"): Decimal
    var
        ShipmentLine: Record "CRF Shipment Line";
        CarrierRate: Record "CRF Carrier Rate";
        Total: Decimal;
        NoRateErr: Label 'Carrier B has no rate for a package of %1 kg.', Comment = '%1 = package weight';
    begin
        // Carrier B prices every package on its own
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        if ShipmentLine.FindSet() then
            repeat
                CarrierRate.SetRange(Carrier, "CRF Carrier"::"Carrier B");
                CarrierRate.SetFilter("Weight Limit", '>=%1', ShipmentLine.Weight);
                if not CarrierRate.FindFirst() then
                    Error(NoRateErr, ShipmentLine.Weight);
                Total += CarrierRate.Price;
            until ShipmentLine.Next() = 0;
        exit(Total);
    end;

    procedure GetStatus(ShipmentHeader: Record "CRF Shipment Header"): Enum "CRF Shipment Status"
    begin
        exit(ShipmentHeader.Status);
    end;
}