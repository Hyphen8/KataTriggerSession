/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 21/09/2021
 * @last modified by  : daniel@hyphen8.com
**/
public with sharing class ContactRollupHandler implements AfterInsert, AfterUpdate, AfterDelete {


    public void handleAfterInsert(List<Contact> contacts){
        Set<ID> accountIds = RollupHelper.accountIds(contacts);
        RollupHelper.rollupAccount(accountIds);      
    }

    public void handleAfterUpdate(List<Contact> oldContacts, List<Contact> newContacts){
        Set<Id> accountIds = RollupHelper.getAccountIdsChanged(oldContacts, newContacts);
        RollupHelper.rollupAccount(accountIds);      
    }

    public void handleAfterDelete(List<Contact> contacts){
        Set<ID> accountIds = RollupHelper.accountIds(contacts);
        RollupHelper.rollupAccount(accountIds); 
    }
    
}
