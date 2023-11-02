pageextension 50106 IMASalesReceivablePageExt extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("IMADefault Customer Class"; Rec."IMADefault Customer Class")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Default Customer Class field.';
            }
        }
    }
}