table 50100 "IMACustomer Class Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Classification Setup';

    fields
    {
        field(1; "Class Code"; Code[1])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Class Code';

        }
        field(5; "Sales Amount From"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Sales Amount From';
            trigger OnValidate()
            begin
                CheckSalesVolumeInterval();
            end;
        }
        field(6; "Sales Amount To"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Sales Amount To';
            trigger OnValidate()
            begin
                CheckSalesVolumeInterval();
            end;

        }
    }

    keys
    {
        key(Key1; "Class Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Class Code", "Sales Amount From", "Sales Amount To")
        {

        }
    }


    trigger OnInsert()
    begin
        CheckSalesVolumeInterval();
    end;

    trigger OnModify()
    begin
        CheckSalesVolumeInterval();
    end;

    trigger OnDelete()
    var
        DeleteRecordErr: Label 'It is not possible to delete a used classification.';
    begin
        if IsUsed() then
            Error(DeleteRecordErr);
    end;

    local procedure CheckSalesVolumeInterval()
    var
        SalesVolumeFromToMissingErr: Label '%1 and %2 cannot be both empty.', Comment = '%1 and %2 are Sales Amount From/To fields values ';
        SalesVolumeIntervalErr: Label '%1 cannot be greater than %3, %1=%2,%3=%4.', Comment = '%1 and %3 are Sales Amount From/To fields captions. %2 and %4 are Sales Amount From/To fields values.';
    begin
        if ("Sales Amount From" = 0) and ("Sales Amount To" = 0) then
            Error(SalesVolumeFromToMissingErr);
        if "Sales Amount To" > 0 then
            if "Sales Amount From" > "Sales Amount To" then
                Error(SalesVolumeIntervalErr, Rec."Sales Amount From", Rec.FieldCaption("Sales Amount From"), Rec."Sales Amount To", Rec.FieldCaption("Sales Amount To"));
    end;

    local procedure IsUsed(): Boolean
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("IMAClass Code", rec."Class Code");
        exit(not Customer.IsEmpty());
    end;
}