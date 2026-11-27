codeunit 50105 "CRF Assisted Setup Subs"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, true)]
    local procedure RegisterFreightSetupGuide()
    var
        GuidedExperience: Codeunit "Guided Experience";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        TitleTxt: Label 'Set up Cronus Freight';
        ShortTitleTxt: Label 'Cronus Freight';
        DescriptionTxt: Label 'Choose the default carrier and the number series for shipments.';
    begin
        if GuidedExperience.Exists("Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"CRF Freight Setup Guide") then
            exit;
        GuidedExperience.InsertAssistedSetup(
            TitleTxt, ShortTitleTxt, DescriptionTxt, 3, ObjectType::Page, Page::"CRF Freight Setup Guide",
            AssistedSetupGroup::ReadyForBusiness, '', VideoCategory::Uncategorized, '');
    end;
}