page 50105 "CRF Carrier Rates"
{
    PageType = List;
    SourceTable = "CRF Carrier Rate";
    Caption = 'Carrier Rates';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Rates)
            {
                field(Carrier; Rec.Carrier) { }
                field("Weight Limit"; Rec."Weight Limit") { }
                field(Price; Rec.Price) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportRates)
            {
                Caption = 'Import Rates';
                Image = Import;

                trigger OnAction()
                begin
                    XmlPort.Run(XmlPort::"CRF Import Carrier Rates", false, true);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}