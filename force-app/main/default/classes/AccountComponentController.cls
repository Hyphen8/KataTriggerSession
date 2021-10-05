/**
 * @description  : Controller for Account List LWC
 * @author       : simon@hyphen8.com
 * @created      : 05/10/2021
**/
public with sharing class AccountComponentController {
    @AuraEnabled
    public static List<Contact> getContacts(Id accountId){
        Set<String> fieldsToShow = new Set<String>{
            'FirstName',
            'LastName',
            'Email',
            'Phone',
            'Account.Name'
        };

        String contactQuery = new QueryBuilder('Contact')
            .addFields(fieldsToShow)
            .setWhereClause('Email != null')
            .setOrderByClause('LastName ASC')
            .getQuery();

            return Database.query(contactQuery);
    }

    @AuraEnabled
    public static List<Account> getAccounts(){
        String fieldSetName = 'AccountDisplayFieldset';

        String accountQuery = new QueryBuilder('Account')
            .addFieldSet(fieldSetName)
            .setWhereClause('Website != NULL')
            .setOrderByClause('Name ASC')
            .getQuery();

        return Database.query(accountQuery);
    }
}
