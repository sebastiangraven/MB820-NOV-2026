codeunit 50108 "CRF Install"
{
    Access = Internal;
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTags: Codeunit "CRF Upgrade Tags";
    begin
        InitFreightSetup();
        // A fresh installation has no 1.0.0.0 data, so the default carrier backfill is already done
        if not UpgradeTag.HasUpgradeTag(UpgradeTags.GetDefaultCarrierTag()) then
            UpgradeTag.SetUpgradeTag(UpgradeTags.GetDefaultCarrierTag());
    end;

    // OnInstallAppPerCompany only runs for the companies that exist now; companies created later get the record here.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure InitFreightSetupOnCompanyInitialize()
    begin
        InitFreightSetup();
    end;

    local procedure InitFreightSetup()
    var
        FreightSetup: Record "CRF Freight Setup";
    begin
        if FreightSetup.Get() then
            exit;
        FreightSetup.Init();
        FreightSetup.Insert();
    end;
}