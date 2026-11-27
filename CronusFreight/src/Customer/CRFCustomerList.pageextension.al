// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.CronosFreight;

using Microsoft.Sales.Customer;

pageextension 50100 "CRF Customer List" extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action(CRFHello)
            {
                ApplicationArea = All;
                Caption = 'Hello from Cronus Freight';
                Tooltip = 'Shows a greeting from the Cronus Freight extension.';

                trigger OnAction();
                var
                    GreetingTxt: Label 'Hello %1, Cronus Fragt is running.', Comment = '%1 = the user ID';
                    Greeting: Text;

                begin
                    Greeting := StrSubstNo(GreetingTxt, UserId());
                    Message(Greeting);
                end;
            }
        }
    }
}