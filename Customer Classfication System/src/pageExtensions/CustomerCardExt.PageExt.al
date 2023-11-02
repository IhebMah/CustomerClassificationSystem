pageextension 50101 IMACustomerCardExt extends "Customer Card"
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