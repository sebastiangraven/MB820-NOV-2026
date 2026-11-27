codeunit 50103 "CRF Freight Mgt"
{
    Access = Public;

    var
        UpdateFailedTitleLbl: Label 'The shipment status wasn''t updated';
        UpdateFailedErr: Label 'Cronus Freight couldn''t get the status of shipment %1 from the carrier. Try again later.', Comment = '%1 = shipment number';

    procedure GetRate(var ShipmentHeader: Record "CRF Shipment Header"): Decimal
    var
        Carrier: Interface "CRF ICarrier";
    begin
        Carrier := ShipmentHeader.Carrier;
        exit(Carrier.GetRate(ShipmentHeader));
    end;

    procedure CreateShipmentFromSalesShipment(CustomerNo: Code[20]; SalesShipmentNo: Code[20])
    var
        ExistingShipment: Record "CRF Shipment Header";
        ShipmentHeader: Record "CRF Shipment Header";
    begin
        ExistingShipment.SetRange("Sales Shipment No.", SalesShipmentNo);
        if not ExistingShipment.IsEmpty() then
            exit;
        ShipmentHeader.Init();
        ShipmentHeader.Insert(true);
        ShipmentHeader.Validate("Customer No.", CustomerNo);
        ShipmentHeader."Sales Shipment No." := SalesShipmentNo;
        ShipmentHeader.Modify(true);
    end;

    procedure UpdateStatus(var ShipmentHeader: Record "CRF Shipment Header")
    var
        UpdateFailedInfo: ErrorInfo;
        ErrorText: Text;
    begin
        if UpdateStatusNoError(ShipmentHeader, ErrorText) then
            exit;

        UpdateFailedInfo.Title := UpdateFailedTitleLbl;
        UpdateFailedInfo.Message := StrSubstNo(UpdateFailedErr, ShipmentHeader."No.");
        UpdateFailedInfo.DetailedMessage := ErrorText;
        Error(UpdateFailedInfo);
    end;

    procedure UpdateStatusNoError(var ShipmentHeader: Record "CRF Shipment Header"; var ErrorText: Text): Boolean
    var
        Carrier: Interface "CRF ICarrier";
        NewStatus: Enum "CRF Shipment Status";
    begin
        ErrorText := '';
        Carrier := ShipmentHeader.Carrier;
        if not TryGetStatus(Carrier, ShipmentHeader, NewStatus) then begin
            ErrorText := GetLastErrorText();
            exit(false);
        end;

        if NewStatus <> ShipmentHeader.Status then begin
            ShipmentHeader.Validate(Status, NewStatus);
            ShipmentHeader.Modify(true);
        end;
        exit(true);
    end;

    [TryFunction]
    local procedure TryGetStatus(Carrier: Interface "CRF ICarrier"; ShipmentHeader: Record "CRF Shipment Header"; var NewStatus: Enum "CRF Shipment Status")
    begin
        // no database writes in here
        NewStatus := Carrier.GetStatus(ShipmentHeader);
    end;
}