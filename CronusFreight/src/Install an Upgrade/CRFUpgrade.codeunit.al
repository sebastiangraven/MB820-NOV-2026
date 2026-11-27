codeunit 50109 "CRF Upgrade"
{
    Access = Internal;
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "CRF Upgrade Tags";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTags.GetDefaultCarrierTag()) then
            exit;
        FillDefaultCarrierFromShipments();
        UpgradeTag.SetUpgradeTag(UpgradeTags.GetDefaultCarrierTag());
    end;

    // Customers without a default carrier get the carrier of their latest shipment (highest number).
    local procedure FillDefaultCarrierFromShipments()
    var
        Customer: Record Customer;
        ShipmentHeader: Record "CRF Shipment Header";
    begin
        Customer.SetRange("CRF Default Carrier", Customer."CRF Default Carrier"::" ");
        if Customer.FindSet(true) then
            repeat
                ShipmentHeader.SetRange("Customer No.", Customer."No.");
                ShipmentHeader.SetFilter(Carrier, '<>%1', ShipmentHeader.Carrier::" ");
                if ShipmentHeader.FindLast() then begin
                    Customer."CRF Default Carrier" := ShipmentHeader.Carrier;
                    Customer.Modify();
                end;
            until Customer.Next() = 0;
    end;
}