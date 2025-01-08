public with sharing class accountDataService {

    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts() {
        return [
                SELECT Name, Id
                FROM Account
                WITH SECURITY_ENFORCED
                ORDER BY Name
        ];
    }
}