codeunit 50100 IMACalculateCustomerClass
{
    trigger onRun()
    var
        Customer: Record Customer;
        ClassCode: Code[1];
    begin
        Customer.SetLoadFields("No.");
        Customer.SetAutoCalcFields("Sales (LCY)");
        Customer.SetRange("Date Filter", CalcDate('<-CY-1Y>', Today()), CalcDate('<CY-1Y>', Today()));
        if Customer.FindSet(true) then
            repeat
                if GetCustomerClassificationFromSalesAmount(Customer."Sales (LCY)", ClassCode) then begin
                    Customer."IMAClass Code" := ClassCode;
                    Customer.Modify(false);
                end;
            until Customer.Next() = 0;

    end;

    local procedure GetCustomerClassificationFromSalesAmount(SalesAmount: Decimal; var ClassCode: Code[1]): Boolean
    var
        CustomerClassSetup: Record "IMACustomer Class Setup";
    begin
        CustomerClassSetup.SetFilter("Sales Amount From", '<=%1|0', SalesAmount);
        CustomerClassSetup.SetFilter("Sales Amount To", '>=%1|0', SalesAmount);
        if CustomerClassSetup.FindFirst() then begin
            ClassCode := CustomerClassSetup."Calss Code";
            exit(true);
        end;
    end;
}