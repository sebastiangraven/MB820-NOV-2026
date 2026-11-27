page 50109 "CRF Shipment Line API"
{
    PageType = API;
    Caption = 'Shipment Line API';
    APIPublisher = 'cronus';
    APIGroup = 'freight';
    APIVersion = 'v1.0';
    EntityName = 'shipmentLine';
    EntitySetName = 'shipmentLines';
    EntityCaption = 'Shipment Line';
    EntitySetCaption = 'Shipment Lines';
    SourceTable = "CRF Shipment Line";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(shipmentNumber; Rec."Shipment No.")
                {
                    Caption = 'Shipment No.';
                }
                field(lineNumber; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(weight; Rec.Weight)
                {
                    Caption = 'Weight';
                }
                field(length; Rec.Length)
                {
                    Caption = 'Length';
                }
                field(width; Rec.Width)
                {
                    Caption = 'Width';
                }
                field(height; Rec.Height)
                {
                    Caption = 'Height';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
            }
        }
    }
}