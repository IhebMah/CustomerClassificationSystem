codeunit 60100 "IMATest Customer Class. System"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure TestCreateCustomerClass()
    var
        CustomerClassSetup: Record "IMACustomer Class Setup";
        LibraryAssert: Codeunit "Library Assert";
        SalesAmountFrom: Decimal;
        SalesAmountTo: Decimal;
    begin
        // [Given] Préparation des données de test
        Initialize();

        SalesAmountFrom := 100000;
        SalesAmountTo := 149999;

        // [When] Créer une nouvelle classification client
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'X';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        // [Then] Validation du résultat attendu
        LibraryAssert.IsTrue(CustomerClassSetup.Get(CustomerClassSetup."Class Code"), 'Échoué : Impossible de récupérer la classification client après l''ajout.');
        LibraryAssert.AreEqual('X', CustomerClassSetup."Class Code", '');
        LibraryAssert.AreEqual(SalesAmountFrom, CustomerClassSetup."Sales Amount From", '');
        LibraryAssert.AreEqual(SalesAmountTo, CustomerClassSetup."Sales Amount To", '');
    end;

    [Test]
    procedure TestAddClientWithDefaultClass()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        LibraryAssert: Codeunit "Library Assert";
    begin
        // [Given] Préparation des données de test : Créez une classification client par défaut
        Initialize();
        InsertClassificationSetupAndDefaultValue();
        SalesReceivablesSetup.Get();

        // [When] Création d'un nouveau client
        Customer.Init();
        Customer.Insert(true);

        // [Then] Validation du résultat attendu
        LibraryAssert.AreEqual(SalesReceivablesSetup."IMADefault Customer Class", Customer."IMAClass Code", 'Échoué : La classification client par default n''est pas correctemnet assigner a la client.');
    end;

    [Test]
    procedure TestModifyClientClassAuthorizedUser()
    var
        Customer: Record Customer;
        LibraryAssert: Codeunit "Library Assert";
    begin
        // [Given] Créez un client avec une classification
        Initialize();
        InsertClassificationSetupAndDefaultValue();

        Customer.Init();
        Customer.Insert(true);

        // [GIVEN] Authoriser l'utilisateur a modifier la classificassion manuellement
        AllowUserEditCustomerClass(true);

        // [When] Modification manuelle de la classification
        Customer.Validate("IMAClass Code", 'D');
        Customer.Modify();


        // [Then] Validation du résultat attendu
        LibraryAssert.AreEqual(Customer."IMAClass Code", 'D', 'Échoué : La classification client ne peux pas etre modifier manuellement par un utilisateur authorize.');
    end;

    [Test]
    procedure TestModifyClientClassNonAuthorizedUser()
    var
        Customer: Record Customer;
        LibraryAssert: Codeunit "Library Assert";
    begin
        // [Given]  Créez un client avec une classification
        Initialize();
        InsertClassificationSetupAndDefaultValue();

        Customer.Init();
        Customer.Insert(true);

        // [GIVEN] Ne pas authoriser l'utilisateur a modifier la classificassion manuellement
        AllowUserEditCustomerClass(false);

        // [When] Modification manuelle de la classification
        asserterror Customer.Validate("IMAClass Code", 'D');

        // [Then] Validation du résultat attendu
        LibraryAssert.AreNotEqual(Customer."IMAClass Code", 'D', 'Échoué : La classification client ne devra pas etre modifier par un utilisateur non-authorize.');
    end;

    [Test]
    procedure TestAutomaticAnnualClassCalculation()
    var
        Customer: Record "Customer";
        LibraryAssert: Codeunit "Library Assert";
    begin
        // [Given] Créez un client sans vente reelles
        Initialize();
        InsertClassificationSetupAndDefaultValue();

        Customer.Init();
        Customer.Insert(true);

        // [When] Exécution du calcul automatique annuel
        Codeunit.Run(Codeunit::IMACalculateCustomerClass);
        Customer.Get(Customer."No.");

        // [Then] Validation du résultat attendu
        LibraryAssert.AreEqual(Customer."IMAClass Code", 'E', 'Échoué : La classification n''est pas calculer correctement.');
    end;

    [Test]
    procedure TestCreateCustomerClassWithWrongInterval()
    var
        CustomerClassSetup: Record "IMACustomer Class Setup";
        LibraryAssert: Codeunit "Library Assert";
        SalesAmountFrom: Decimal;
        SalesAmountTo: Decimal;
    begin
        // [Given] Préparation des données de test
        Initialize();

        SalesAmountFrom := 200000;
        SalesAmountTo := 15000;

        // [When] Créer une nouvelle classification client
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'X';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        asserterror CustomerClassSetup.Insert(true);

        // [Then] Validation du résultat attendu
        LibraryAssert.IsFalse(CustomerClassSetup.Get('X'), 'Échoué : la classification client ne devrais pas exister.');
    end;

    [Test]
    procedure TestDeleteClassAssignedToClient()
    var
        Customer: Record "Customer";
        CustomerClassSetup: Record "IMACustomer Class Setup";
        LibraryAssert: Codeunit "Library Assert";
        SalesAmountFrom: Decimal;
        SalesAmountTo: Decimal;
    begin
        // [Given] Préparation des données de test : Créez une classification client attribuée à un client
        Initialize();

        SalesAmountFrom := 100000;
        SalesAmountTo := 149999;

        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'X';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        Customer.Init();
        Customer."IMAClass Code" := CustomerClassSetup."Class Code";
        Customer.Insert(true);

        // [When] Tentative de suppression de la classification client
        asserterror CustomerClassSetup.Delete(true);

        // [Then] Validation du résultat attendu
        LibraryAssert.ExpectedError('It is not possible to delete a used classification.');
    end;

    local procedure Initialize()
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CustomerClassSetup: Record "IMACustomer Class Setup";
    begin
        Customer.ModifyAll("IMAClass Code", '');
        SalesReceivablesSetup.ModifyAll("IMADefault Customer Class", '');
        CustomerClassSetup.DeleteAll();
    end;

    local procedure InsertClassificationSetupAndDefaultValue()
    var
        CustomerClassSetup: Record "IMACustomer Class Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesAmountFrom: Decimal;
        SalesAmountTo: Decimal;
    begin
        SalesAmountFrom := 200000;
        SalesAmountTo := 0;
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'A';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        SalesAmountFrom := 150000;
        SalesAmountTo := 199999;
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'B';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        SalesAmountFrom := 100000;
        SalesAmountTo := 149999;
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'C';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        SalesAmountFrom := 50000;
        SalesAmountTo := 99999;
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'D';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();

        SalesAmountFrom := 0;
        SalesAmountTo := 49999;
        CustomerClassSetup.Init();
        CustomerClassSetup."Class Code" := 'E';
        CustomerClassSetup."Sales Amount From" := SalesAmountFrom;
        CustomerClassSetup."Sales Amount To" := SalesAmountTo;
        CustomerClassSetup.Insert();


        SalesReceivablesSetup.Get();
        SalesReceivablesSetup."IMADefault Customer Class" := 'E';
        SalesReceivablesSetup.Modify();
    end;

    local procedure AllowUserEditCustomerClass(Allow: Boolean)
    var
        UserSetup: Record "User Setup";
    begin
        if not userSetup.get(UserId) then begin
            userSetup.Init();
            userSetup."User ID" := CopyStr(UserId(), 1, MaxStrlen(userSetup."User ID"));
            userSetup."IMAAllow Edit Customer Class" := Allow;
            userSetup.Insert();
        end else begin
            userSetup."IMAAllow Edit Customer Class" := Allow;
            userSetup.Modify();
        end;
    end;

}