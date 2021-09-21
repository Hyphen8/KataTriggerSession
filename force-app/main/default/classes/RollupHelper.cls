/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 14/09/2021
 * @last modified by  : daniel@hyphen8.com
**/
public with sharing class RollupHelper {

    public static Set<ID> accountIds(List<Contact> contacts){
        Set<ID> returnSet = new Set<ID>();
        for(Contact con : contacts){
            returnSet.add(con.AccountId);                     
        }
        return returnSet;
    }


    public static void rollupAccount(Set<ID> accountIds){

        // Number_of_Contacts__c fieldName on account to populate

        AggregateResult[] groupedResults = [SELECT AccountId, COUNT(id) FROM Contact WHERE AccountId IN: accountIds GROUP BY AccountId];

        List<Account> accToUpdate = new List<Account>();
        
        Map<ID, Integer> mapOfAccounts = new Map<ID, Integer>();

        for(AggregateResult ar : groupedResults){
            string accountId = (string)ar.get('AccountId');
            integer accountCount = (integer)ar.get('expr0');
            mapOfAccounts.put(accountId, accountCount);
        }

        for(ID accountId:accountIds){
            integer recordCount = 0;
            if(mapOfAccounts.containsKey(accountId)){
                recordCount = mapOfAccounts.get(accountId);
            }
            Account acc = new Account(id=accountId);
            acc.Number_of_Contacts__c = recordCount;
            accToUpdate.add(acc);
        }

        update accToUpdate;
        
    }
    
}

        