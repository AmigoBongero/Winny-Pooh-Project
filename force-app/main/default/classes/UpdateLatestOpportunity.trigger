trigger UpdateLatestOpportunity on Opportunity (after insert) {
    Set<Id> accountIds = new Set<Id>();
    Map<Id, Opportunity> newOpportunities = new Map<Id, Opportunity>();

    for (Opportunity opp : Trigger.new) {
        if (opp.AccountId != null) {
            accountIds.add(opp.AccountId);
            newOpportunities.put(opp.Id, opp);
        }
    }

    List<Opportunity> relatedOpportunities = [
            SELECT Id, AccountId
            FROM Opportunity
            WHERE AccountId IN :accountIds
    ];

    List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

    for (Opportunity relatedOpp : relatedOpportunities) {
        if (!newOpportunities.containsKey(relatedOpp.Id)) {
            relatedOpp.Latest_Opportunity_on_related_Account__c = newOpportunities.values()[0].Id;
            opportunitiesToUpdate.add(relatedOpp);
        }
    }

    if (!opportunitiesToUpdate.isEmpty()) {
        update opportunitiesToUpdate;
    }
}