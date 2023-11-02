pageextension 50105 IMASalesInvoiceExt extends "Sales Invoice"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("IMACustomer Class Code"; Rec."IMACustomer Class Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Class Code field.';
            }
        }
    }
}