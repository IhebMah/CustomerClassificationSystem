page 50100 "IMACustomer Class Setup"
{
    Caption = 'Customer Classification Setup';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "IMACustomer Class Setup";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Calss Code"; Rec."Calss Code")
                {
                    ToolTip = 'Specifies the value of the Class Code field.';
                }
                field("Sales Amount From"; Rec."Sales Amount From")
                {
                    ToolTip = 'Specifies the value of the Sales Amount From field.';
                }
                field("Sales Amount To"; Rec."Sales Amount To")
                {
                    ToolTip = 'Specifies the value of the Sales Amount To field.';
                }
            }
        }
    }
}