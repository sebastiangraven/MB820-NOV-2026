codeunit 50104 "CRF Sales Post Subs"

{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]

    local procedure CreateShipmentOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)

    var

        FreightMgt: Codeunit "CRF Freight Mgt";

    begin

        if PreviewMode or (SalesShptHdrNo = '') then
            exit;

        FreightMgt.CreateShipmentFromSalesShipment(SalesHeader."Sell-to Customer No.", SalesShptHdrNo);

    end;

}

