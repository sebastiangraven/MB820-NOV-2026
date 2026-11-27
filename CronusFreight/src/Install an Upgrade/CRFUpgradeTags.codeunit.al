codeunit 50110 "CRF Upgrade Tags"
{
    Access = Internal;

    procedure GetDefaultCarrierTag(): Code[250]
    begin
        // [CompanyPrefix]-[ID]-[Description]-[YYYYMMDD]
        exit('CRF-DefaultCarrierFromShipments-20261117');
    end;

    // Makes the tag exist in companies created later, so the backfill does not run there.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterPerCompanyTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetDefaultCarrierTag());
    end;
}