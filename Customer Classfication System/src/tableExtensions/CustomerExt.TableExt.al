tableextension 50100 IMACustomerExt extends Customer
{
    fields
    {
        field(50100; "IMAClass Code"; Code[1])
        {
            Caption = 'Classification Code';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "IMACustomer Class Setup"."Class Code";
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                PermissionsMissingErr: label 'You are not allowed to modify this value manually.';
            begin
                UserSetup.Get(UserId);
                if not UserSetup."IMAAllow Edit Customer Class" then
                    error(PermissionsMissingErr);
            end;
        }

    }
    fieldgroups
    {
        addlast(Brick; "IMAClass Code")
        {

        }
    }

    trigger OnAfterInsert()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesReceivablesSetup.Get() then
            Rec."IMAClass Code" := SalesReceivablesSetup."IMADefault Customer Class";
    end;

}