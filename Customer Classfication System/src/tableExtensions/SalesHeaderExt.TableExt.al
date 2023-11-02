tableextension 50101 IMASalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50100; "IMACustomer Class Code"; Code[1])
        {
            Caption = 'Customer Class Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."IMAClass Code" where("No." = field("Sell-to Customer No.")));
        }
    }

}