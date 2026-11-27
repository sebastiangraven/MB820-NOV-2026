table 50104 "CRF Freight Cue"
{
    Caption = 'Freight Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Open Shipments"; Integer)
        {
            Caption = 'Open Shipments';
            FieldClass = FlowField;
            CalcFormula = count("CRF Shipment Header" where(Status = const(Open)));
        }
        field(3; "Open Default Carrier"; Integer)
        {
            Caption = 'Open with Default Carrier';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}