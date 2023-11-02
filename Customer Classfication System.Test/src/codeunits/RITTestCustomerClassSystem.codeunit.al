codeunit 60100 "RITTest Customer Class. System"
{
    Subtype = Test;


    [Test]
    procedure TestCreateCustomerClass()
    var
        CustomerClassSetup: Record "IMACustomer Class Setup";
        Assert: Codeunit "Library Assert";
        SalesAmountFrom: Decimal;
        SalesAmountTo: Decimal;
    begin
        // [Given] Préparation des données de test
        SalesAmountFrom := 100000;
        SalesAmountTo := 149999;

        // [When] Créer une nouvelle classification client
        CustomerClassSetup.Init();
        CustomerClassSetup."Calss Code" := 'A';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        // [Then] Validation du résultat attendu
        Assert.IsTrue(CustomerClassSetup.Get(CustomerClassSetup."Calss Code"), 'Échoué : Impossible de récupérer la classification client après l''ajout.');
        Assert.AreEqual('A', CustomerClassSetup."Calss Code", '');
        Assert.AreEqual(SalesAmountFrom, CustomerClassSetup."Sales Amount From", '');
        Assert.AreEqual(SalesAmountTo, CustomerClassSetup."Sales Amount To", '');
    end;



}