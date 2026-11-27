page 50108 "CRF Freight Activities"
{
    PageType = CardPart;
    SourceTable = "CRF Freight Cue";
    Caption = 'Freight';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            cuegroup(Shipments)
            {
                Caption = 'Shipments';

                field("Open Shipments"; Rec."Open Shipments")
                {
                    DrillDownPageId = "CRF Shipment List";
                }
                field("Open Default Carrier"; Rec."Open Default Carrier") { }

                actions
                {
                    action(AllShipments)
                    {
                        Caption = 'All Shipments';
                        RunObject = page "CRF Shipment List";
                        Image = TileNew;
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    trigger OnAfterGetRecord()
    var
        FreightSetup: Record "CRF Freight Setup";
        ShipmentHeader: Record "CRF Shipment Header";
    begin
        Rec."Open Default Carrier" := 0;
        if not FreightSetup.Get() then
            exit;

        ShipmentHeader.SetRange(Status, "CRF Shipment Status"::Open);
        ShipmentHeader.SetRange(Carrier, FreightSetup."Default Carrier");
        Rec."Open Default Carrier" := ShipmentHeader.Count();
    end;
}