page 50102 "CRF Shipment Card"
{
    PageType = Document;
    SourceTable = "CRF Shipment Header";
    Caption = 'Shipment';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { }
                field("Customer No."; Rec."Customer No.") { }
                field(Carrier; Rec.Carrier) { }
                field(Status; Rec.Status) { }
                field("Tracking No."; Rec."Tracking No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Total Weight"; Rec."Total Weight") { }
            }
            part(Lines; "CRF Shipment Subform")
            {
                Caption = 'Packages';
                SubPageLink = "Shipment No." = field("No.");
                UpdatePropagation = Both;
            }
            group(Shipping)
            {
                Caption = 'Ship-to';
                field("Ship-to Name"; Rec."Ship-to Name") { }
                field("Ship-to Address"; Rec."Ship-to Address") { }
                field("Ship-to Post Code"; Rec."Ship-to Post Code") { }
                field("Ship-to City"; Rec."Ship-to City") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateStatus)
            {
                Caption = 'Update Status';
                Image = Refresh;

                trigger OnAction()
                var
                    FreightMgt: Codeunit "CRF Freight Mgt";
                begin
                    FreightMgt.UpdateStatus(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}