codeunit 50107 "CRF Update Status"
{
    trigger OnRun()
    var
        ShipmentHeader: Record "CRF Shipment Header";
        ShipmentToUpdate: Record "CRF Shipment Header";
        FreightMgt: Codeunit "CRF Freight Mgt";
        ErrorText: Text;
    begin
        ShipmentHeader.SetFilter(Status, '%1|%2', ShipmentHeader.Status::Booked, ShipmentHeader.Status::"In Transit");
        ShipmentHeader.SetFilter("Tracking No.", '<>%1', '');
        if ShipmentHeader.FindSet() then
            repeat
                ShipmentToUpdate.Get(ShipmentHeader."No.");
                if not FreightMgt.UpdateStatusNoError(ShipmentToUpdate, ErrorText) then
                    LogFailure(ShipmentToUpdate);
            until ShipmentHeader.Next() = 0;
    end;

    local procedure LogFailure(ShipmentHeader: Record "CRF Shipment Header")
    var
        Dimensions: Dictionary of [Text, Text];
    begin
        // No. is CustomerContent (module 3b), so log the SystemId instead
        Dimensions.Add('ShipmentSystemId', Format(ShipmentHeader.SystemId));
        Dimensions.Add('Carrier', Format(ShipmentHeader.Carrier));
        Session.LogMessage('CRF-0001', 'Shipment status update from the carrier failed', Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, Dimensions);
    end;
}