table 50102 "CRF Shipment Line"
{
    Caption = 'Shipment Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            DataClassification = CustomerContent;
            TableRelation = "CRF Shipment Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; Weight; Decimal)
        {
            Caption = 'Weight (kg)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                WeightMustBePositiveErr: Label 'The weight of a package must be greater than zero.';
            begin
                if Rec.Weight <= 0 then
                    Error(WeightMustBePositiveErr);
            end;
        }
        field(5; Length; Decimal)
        {
            Caption = 'Length (cm)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(6; Width; Decimal)
        {
            Caption = 'Width (cm)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(7; Height; Decimal)
        {
            Caption = 'Height (cm)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(PK; "Shipment No.", "Line No.")
        {
            Clustered = true;
        }
    }
}