tableextension 50102 IMASalesReceivableSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "IMADefault Customer Class"; Code[1])
        {
            Caption = 'Default Customer Class';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "IMACustomer Class Setup";
            ValidateTableRelation = true;
        }
    }
}