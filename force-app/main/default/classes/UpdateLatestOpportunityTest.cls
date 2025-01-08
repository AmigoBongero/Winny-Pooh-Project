@IsTest
private class UpdateLatestOpportunityTest {
    @TestSetup
    static void loadTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account acc : accounts) {
            opportunities.add(
                    new Opportunity(
                            Name = 'Initial Opportunity',
                            AccountId = acc.Id,
                            CloseDate = Date.today(),
                            StageName = 'Prospecting'
                            ));
        }
        insert opportunities;
    }

    @IsTest
    static void testUpdateLatestOpportunity() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 3];

        List<Opportunity> newOpportunities = new List<Opportunity>();
        for (Integer i = 0; i < 2; i++) {
            newOpportunities.add(
                    new Opportunity(
                            Name = 'New Opportunity ' + i,
                            AccountId = accounts[i].Id,
                            StageName = 'Prospecting',
                            CloseDate = Date.today()));
        }
        insert newOpportunities;

        Set<Id> newOppIds = new Set<Id>();
        for (Opportunity opp : newOpportunities) {
            newOppIds.add(opp.Id);
        }

        List<Opportunity> updatedOpportunities = [
                SELECT Id, AccountId, Latest_Opportunity_on_related_Account__c
                FROM Opportunity
                WHERE AccountId = :newOpportunities[0].AccountId];

        for (Opportunity opp : updatedOpportunities) {
            if (!newOppIds.contains(opp.Id)) {
                System.assertEquals(newOpportunities[0].Id, opp.Latest_Opportunity_on_related_Account__c);
            }
        }
    }
}