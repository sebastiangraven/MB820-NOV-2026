page 50103 "CRF Shipment Subform"
{
    PageType = ListPart;
    SourceTable = "CRF Shipment Line";
    Caption = 'Packages';
    AutoSplitKey = true;
    DelayedInsert = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Packages)
            {
                field(Description; Rec.Description) { }
                field(Weight; Rec.Weight)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Length; Rec.Length) { }
                field(Width; Rec.Width) { }
                field(Height; Rec.Height) { }
            }
        }
    }
}