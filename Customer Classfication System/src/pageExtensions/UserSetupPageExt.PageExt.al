pageextension 50106 IMAUserSetupPageExt extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("IMAAllow Edit Customer Class"; Rec."IMAAllow Edit Customer Class")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Edit Customer Class field.';
            }
        }
    }
}