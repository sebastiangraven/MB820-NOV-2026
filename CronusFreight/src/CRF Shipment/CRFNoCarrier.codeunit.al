codeunit 50106 "CRF No Carrier" implements "CRF ICarrier"
{
    Access = Internal;

    var
        NoCarrierErr: Label 'Shipment %1 has no carrier. Choose a carrier on the shipment first.', Comment = '%1 = shipment number';

    procedure GetRate(ShipmentHeader: Record "CRF Shipment Header"): Decimal
    begin
        Error(NoCarrierErr, ShipmentHeader."No.");
    end;

    procedure GetStatus(ShipmentHeader: Record "CRF Shipment Header"): Enum "CRF Shipment Status"
    begin
        Error(NoCarrierErr, ShipmentHeader."No.");
    end;
}