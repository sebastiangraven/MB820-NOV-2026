page 50101 "CRF Shipment List"
{
    PageType = List;
    SourceTable = "CRF Shipment Header";
    Caption = 'Shipments';
    CardPageId = "CRF Shipment Card";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Shipments)
            {
                field("No."; Rec."No.") { }
                field("Customer No."; Rec."Customer No.") { }
                field(Carrier; Rec.Carrier) { }
                field(Status; Rec.Status) { }
                field("Total Weight"; Rec."Total Weight") { }
            }
        }
    }
}