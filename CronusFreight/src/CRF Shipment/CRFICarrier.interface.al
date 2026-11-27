interface "CRF ICarrier"
{
    procedure GetRate(ShipmentHeader: Record "CRF Shipment Header"): Decimal;
    procedure GetStatus(ShipmentHeader: Record "CRF Shipment Header"): Enum "CRF Shipment Status";
}