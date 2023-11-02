tableextension 50100 IMACustomerExt extends Customer
{
    fields
    {
        field(50100; "IMAClass Code"; Code[1])
        {
            Caption = 'Classification Code';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "IMACustomer Class Setup"."Calss Code";
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                UserPermissions: Codeunit "User Permissions";
                ModulInfo: ModuleInfo;
                RoleID: Code[20];
                PermissionsMissingErr: label 'You do not have the right permission to modify this value manually.';
            begin
                RoleID := 'IMACCS ADMIN';
                if NavApp.GetCurrentModuleInfo(ModulInfo) then
                    if not UserPermissions.HasUserPermissionSetAssigned(UserSecurityId(), CurrentCompany, RoleID, 0, ModulInfo.Id) then
                        Error(PermissionsMissingErr);

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