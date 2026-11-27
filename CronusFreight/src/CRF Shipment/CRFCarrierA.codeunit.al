codeunit 50101 "CRF Carrier A" implements "CRF ICarrier"
{
    Access = Internal;

    procedure GetRate(ShipmentHeader: Record "CRF Shipment Header"): Decimal
    var
        CarrierRate: Record "CRF Carrier Rate";
        NoRateErr: Label 'Carrier A has no rate for a shipment of %1 kg.', Comment = '%1 = total weight';
    begin
        ShipmentHeader.CalcFields("Total Weight");
        CarrierRate.SetRange(Carrier, "CRF Carrier"::"Carrier A");
        CarrierRate.SetFilter("Weight Limit", '>=%1', ShipmentHeader."Total Weight");
        if not CarrierRate.FindFirst() then
            Error(NoRateErr, ShipmentHeader."Total Weight");
        exit(CarrierRate.Price);
    end;

    procedure GetStatus(ShipmentHeader: Record "CRF Shipment Header"): Enum "CRF Shipment Status"
    var
        FreightSetup: Record "CRF Freight Setup";
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
        Body: JsonObject;
        StatusToken: JsonToken;
        ServiceStatusErr: Label 'The carrier service answered %1 %2.', Comment = '%1 = HTTP status code, %2 = reason phrase';
        InvalidResponseErr: Label 'The carrier service sent an answer that Cronus Freight can''t read.';
    begin
        FreightSetup.Get();
        FreightSetup.TestField("API Base URL");
        ShipmentHeader.TestField("Tracking No.");
        Client.Timeout := 30000;
        SendWithRetry(Client, FreightSetup."API Base URL" + '/shipments/' + ShipmentHeader."Tracking No." + '/status', Response);
        if not Response.IsSuccessStatusCode() then
            Error(ServiceStatusErr, Response.HttpStatusCode(), Response.ReasonPhrase());
        Response.Content().ReadAs(ResponseText);
        if not Body.ReadFrom(ResponseText) then
            Error(InvalidResponseErr);
        if not Body.Get('status', StatusToken) then
            Error(InvalidResponseErr);
        exit(StatusFromText(StatusToken.AsValue().AsText()));
    end;

    local procedure SendWithRetry(var Client: HttpClient; Url: Text; var Response: HttpResponseMessage)
    var
        Request: HttpRequestMessage;
        Headers: HttpHeaders;
        FreightSetup: Record "CRF Freight Setup";
        ApiKey: SecretText;
        Attempt: Integer;
        Sent: Boolean;
        ServiceUnreachableErr: Label 'The carrier service couldn''t be reached.';
    begin
        ApiKey := FreightSetup.GetApiKey();
        for Attempt := 1 to 3 do begin
            Clear(Request);
            Request.Method('GET');
            Request.SetRequestUri(Url);
            Request.GetHeaders(Headers);
            Headers.Add('Accept', 'application/json');
            Headers.Add('X-Api-Key', ApiKey);
            Sent := Client.Send(Request, Response);
            if Sent then begin
                if not IsTransient(Response.HttpStatusCode()) then
                    exit;
            end;
            if Attempt < 3 then
                Sleep(2000 * Attempt);
        end;
        if not Sent then
            Error(ServiceUnreachableErr);
    end;

    local procedure IsTransient(StatusCode: Integer): Boolean
    begin
        exit(StatusCode in [429, 502, 503, 504]);
    end;

    internal procedure StatusFromText(StatusText: Text): Enum "CRF Shipment Status"
    var
        UnknownStatusErr: Label 'The carrier service reported the unknown status %1.', Comment = '%1 = status text';
    begin
        case LowerCase(StatusText) of
            'booked':
                exit("CRF Shipment Status"::Booked);
            'in_transit':
                exit("CRF Shipment Status"::"In Transit");
            'delivered':
                exit("CRF Shipment Status"::Delivered);
            else
                Error(UnknownStatusErr, StatusText);
        end;
    end;
}