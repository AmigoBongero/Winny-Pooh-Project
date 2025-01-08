public with sharing class opportunityDataService {

    @AuraEnabled(Cacheable=true)
    public static List<Opportunity> getOpportunities(String selectedAccId){
        return [
                SELECT Id, Name, CloseDate, Amount, Type, StageName, Probability, Description, AccountId, LastModifiedById
                FROM Opportunity
                WHERE AccountId = :selectedAccId
                WITH SECURITY_ENFORCED
                ORDER BY CloseDate DESC
        ];
    }
}