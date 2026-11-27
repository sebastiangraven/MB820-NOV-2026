table 50101 "CRF Shipment Header"
{
    Caption = 'Shipment Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."No." <> xRec."No." then begin
                    FreightSetup.Get();
                    NoSeries.TestManual(FreightSetup."Shipment Nos.");
                    Rec."No. Series" := '';
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if not Customer.Get(Rec."Customer No.") then
                    exit;
                Rec."Ship-to Name" := Customer.Name;
                Rec."Ship-to Address" := Customer.Address;
                Rec."Ship-to City" := Customer.City;
                Rec."Ship-to Post Code" := Customer."Post Code";

                Rec.Carrier := Customer."CRF Default Carrier";
                if (Rec.Carrier = Rec.Carrier::" ") and FreightSetup.Get() then
                    Rec.Carrier := FreightSetup."Default Carrier";
            end;
        }
        field(3; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
        }
        field(4; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            DataClassification = CustomerContent;
        }
        field(5; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            DataClassification = CustomerContent;
        }
        field(6; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            DataClassification = CustomerContent;
        }
        field(7; Carrier; Enum "CRF Carrier")
        {
            Caption = 'Carrier';
            DataClassification = CustomerContent;
        }
        field(8; Status; Enum "CRF Shipment Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(9; "Tracking No."; Text[50])
        {
            Caption = 'Tracking No.';
            DataClassification = CustomerContent;
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(11; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight (kg)';
            FieldClass = FlowField;
            CalcFormula = sum("CRF Shipment Line".Weight where("Shipment No." = field("No.")));
            Editable = false;
        }
        field(13; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Sales Shipment Header"."No.";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(key2; Status)
        {

        }

        // # Database Missing Indexes 
        // | Table Name          | Equality        | Inequality      | Include          | Seeks | Scans | Est. Benefit |
        // |---------------------|-----------------|-----------------|------------------|------:|------:|-------------:|
        // | CRF Shipment Header | [Status]        | [Tracking No_]  | [No_], [Carrier] |     0 | 1 240 |    2 873 410 |
        // | CRF Shipment Header | [Status]        |                 | [No_]            |     0 |   312 |      418 220 |
        // | Sales Line          | [Document Type] | [Shipment Date] |                  |    18 |     4 |       95 010 |
        key(key3; Status, "TrackingNo.")
        {

        }
    }

    trigger OnDelete()
    var
        ShipmentLine: Record "CRF Shipment Line";
    begin
        ShipmentLine.SetRange("Shipment No.", Rec."No.");
        ShipmentLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if Rec."No." = '' then begin
            FreightSetup.Get();
            FreightSetup.TestField("Shipment Nos.");
            Rec."No. Series" := FreightSetup."Shipment Nos.";
            if NoSeries.AreRelated(FreightSetup."Shipment Nos.", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No." := NoSeries.GetNextNo(Rec."No. Series");
        end;

        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := WorkDate();
    end;

    var
        FreightSetup: Record "CRF Freight Setup";
        NoSeries: Codeunit "No. Series";
}