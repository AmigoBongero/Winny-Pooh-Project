@IsTest
private class DataServicesTest {
    @TestSetup
    static void loadTestData() {
        List<Account> testAccounts = new List<Account> {
                new Account(Name = 'Test Account 1'),
                new Account(Name = 'Test Account 2')
        };
        insert testAccounts;

        List<Opportunity> testOpportunities = new List<Opportunity> {
                new Opportunity(
                        Name = 'Test Opportunity 1',
                        AccountId = testAccounts[0].Id,
                        CloseDate = Date.today(),
                        StageName = 'Prospecting'),
                new Opportunity(
                        Name = 'Test Opportunity 2',
                        AccountId = testAccounts[0].Id,
                        CloseDate = Date.today(),
                        StageName = 'Qualification'
                )
        };
        insert testOpportunities;
    }


    @IsTest
    static void accountDataTest() {
        Test.startTest();
        List<Account> accounts = accountDataService.getAccounts();
        Test.stopTest();

        Assert.isFalse(accounts.isEmpty());
        System.assertEquals(2, accounts.size());
        System.assertEquals('Test Account 1', accounts[0].Name);
        System.assertEquals('Test Account 2', accounts[1].Name);
    }

    @IsTest
    static void opportunityDataTest() {
        List<Account> testAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        String selectedAccId = testAccounts[0].Id;

        Test.startTest();
        List<Opportunity> oppList = opportunityDataService.getOpportunities(selectedAccId);
        Test.stopTest();

        Assert.isFalse(oppList.isEmpty());
        System.assertEquals(2, oppList.size());
        System.assertEquals('Test Opportunity 1', oppList[0].Name);
        System.assertEquals('Test Opportunity 2', oppList[1].Name);
    }
}