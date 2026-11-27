page 50104 "CRF Freight Setup Guide"
{
    Caption = 'Set up Cronus Freight';
    PageType = NavigatePage;
    SourceTable = "CRF Freight Setup";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(StepWelcome)
            {
                Caption = 'Welcome';
                InstructionalText = 'This guide sets up the default carrier and the numbering of shipments. Nothing is saved until you choose Finish.';
                Visible = WelcomeVisible;
            }
            group(StepCarrier)
            {
                Caption = 'Default carrier';
                InstructionalText = 'Choose the carrier that new shipments get when the customer has none of its own.';
                Visible = CarrierVisible;

                field("Default Carrier"; Rec."Default Carrier")
                {
                    ToolTip = 'Specifies the carrier that new shipments get by default.';
                }
            }
            group(StepNumbering)
            {
                Caption = 'Shipment numbers';
                InstructionalText = 'Choose the number series that numbers new shipments.';
                Visible = NumberingVisible;

                field("Shipment Nos."; Rec."Shipment Nos.")
                {
                    ToolTip = 'Specifies the number series that is used to number new shipments.';
                }
            }
            group(StepFinish)
            {
                Caption = 'That''s it';
                InstructionalText = 'Choose Finish to save the freight setup.';
                Visible = FinishVisible;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Back)
            {
                Caption = '&Back';
                ToolTip = 'Goes back to the previous step.';
                Enabled = BackEnabled;
                InFooterBar = true;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    SetStep(Step - 1);
                end;
            }
            action(Next)
            {
                Caption = '&Next';
                ToolTip = 'Goes to the next step.';
                Enabled = NextEnabled;
                InFooterBar = true;
                Image = NextRecord;

                trigger OnAction()
                begin
                    SetStep(Step + 1);
                end;
            }
            action(Finish)
            {
                Caption = '&Finish';
                ToolTip = 'Saves the freight setup and closes the guide.';
                Enabled = FinishEnabled;
                InFooterBar = true;
                Image = Approve;

                trigger OnAction()
                begin
                    SaveSetup();
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        Step: Integer;
        WelcomeVisible: Boolean;
        CarrierVisible: Boolean;
        NumberingVisible: Boolean;
        FinishVisible: Boolean;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        FinishEnabled: Boolean;

    trigger OnOpenPage()
    var
        FreightSetup: Record "CRF Freight Setup";
    begin
        Rec.Init();
        if FreightSetup.Get() then
            Rec.TransferFields(FreightSetup);
        Rec.Insert();
        SetStep(1);
    end;

    local procedure SetStep(NewStep: Integer)
    begin
        Step := NewStep;
        WelcomeVisible := Step = 1;
        CarrierVisible := Step = 2;
        NumberingVisible := Step = 3;
        FinishVisible := Step = 4;
        BackEnabled := Step > 1;
        NextEnabled := Step < 4;
        FinishEnabled := Step = 4;
    end;

    local procedure SaveSetup()
    var
        FreightSetup: Record "CRF Freight Setup";
    begin
        if not FreightSetup.Get() then begin
            FreightSetup.Init();
            FreightSetup.Insert();
        end;
        FreightSetup."Default Carrier" := Rec."Default Carrier";
        FreightSetup."Shipment Nos." := Rec."Shipment Nos.";
        FreightSetup.Modify();
    end;
}