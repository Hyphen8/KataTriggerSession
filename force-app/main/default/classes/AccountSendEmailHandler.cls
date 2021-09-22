/**
 * @description  : Class to log Email Sends
 * @author       : simon@hyphen8.com
 * @created      : 21/09/2021
**/
public without sharing class AccountSendEmailHandler implements AfterUpdate {
    public void handleAfterUpdate(List<Account> oldList, List<Account> newList){
        Set<Id> accountIdsToProcess = new Set<Id>();
        for (Integer i = 0 ; i < newList.size() ; i++){
            if (oldList[i].Send_Latest_Email__c != newList[i].Send_Latest_Email__c && 
                newList[i].Send_Latest_Email__c){
                    accountIdsToProcess.add(newList[i].Id);
                }
        }

        if (accountIdsToProcess.isEmpty()){
            return;
        }

        doEmailSend(accountIdsToProcess);
    }

    private void doEmailSend(Set<Id> accountIdsToProcess){
        Map<Id, Map<String, List<Contact>>> contactsByAccountByEmail = new Map<Id, Map<String, List<Contact>>>();
        for (Contact contact : [
            SELECT Id, FirstName, LastName, Email, AccountId
            FROM Contact
            WHERE AccountId IN :accountIdsToProcess
        ]){
            if (!contactsByAccountByEmail.containsKey(contact.AccountId)){
                contactsByAccountByEmail.put(contact.AccountId, new Map<String, List<Contact>>());
                Map<String, List<Contact>> contactsByEmail = contactsByAccountByEmail.get(contact.AccountId);
                if (!contactsByEmail.containsKey(contact.Email)){
                    contactsByEmail.put(contact.Email, new List<Contact>{contact});
                }else {
                    contactsByEmail.get(contact.Email).add(contact);
                }
                contactsByAccountByEmail.put(contact.AccountId, contactsByEmail);
            }else {
                Map<String, List<Contact>> contactsByEmail = contactsByAccountByEmail.get(contact.AccountId);
                if (!contactsByEmail.containsKey(contact.Email)){
                    contactsByEmail.put(contact.Email, new List<Contact>{contact});
                }else {
                    contactsByEmail.get(contact.Email).add(contact);
                }
                contactsByAccountByEmail.put(contact.AccountId, contactsByEmail);
            }
            
            
        }

        Map<String, List<Email_Log__c>> emailLogsByContactEmail = new Map<String, List<Email_Log__c>>();
        for (Email_Log__c emailLog : [
            SELECT Id, First_Name__c, Last_Name__c, Email__c, Last_Email_Sent__c
            FROM Email_Log__c
            WHERE Account__c IN :accountIdsToProcess
        ]){
            if (!emailLogsByContactEmail.containsKey(emailLog.Email__c)){
                emailLogsByContactEmail.put(emailLog.Email__c, new List<Email_Log__c>{emailLog});
            }else {
                emailLogsByContactEmail.get(emailLog.Email__c).add(emailLog);
            }
        }

        List<Email_Log__c> emailLogsToSave = new List<Email_Log__c>();
        for (Id accountId : accountIdsToProcess){
            Map<String, List<Contact>> contactsByEmail = contactsByAccountByEmail.get(accountId);
            for (String emailAddress : contactsByEmail.keySet()){
                List<Contact> contacts = contactsByEmail.get(emailAddress);
                List<Email_Log__c> emailLogs = emailLogsByContactEmail.get(emailAddress);
                //TODO:  What if there are no Email Logs yet?
                //TODO:  We have enough information here to create one, using Contact data
                for (Email_Log__c emailLog : emailLogs){
                    emailLog.Last_Email_Sent__c = System.now();
                    emailLogsToSave.add(emailLog);
                }
            }
        }

        //TODO:  Update or should this be UPSERT?
        update emailLogsToSave;
    }
}
