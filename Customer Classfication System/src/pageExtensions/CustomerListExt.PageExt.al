pageextension 50100 IMACustomerListExt extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("IMAClass Code"; Rec."IMAClass Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Classification Code field.';
            }
        }
    }
}