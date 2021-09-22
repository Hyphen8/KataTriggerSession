/**
 * @description  : Controller for Account List LWC
 * @author       : simon@hyphen8.com
 * @created      : 22/09/2021
**/
public with sharing class AccountComponentController {
    @AuraEnabled
    public static List<Account> getAccounts(){
        //TODO: Update to use QueryBuilder with FieldSet / DescribeCache
        String fieldSetName = 'AccountDisplayFieldset';
        Set<String> fieldsToQuery = new Set<String>();

        List<FieldSetMember> fieldsetMembers = Account.SObjectType.getDescribe().fieldSets.getMap().get(fieldSetName).getFields();
        for(Schema.FieldSetMember thisField : fieldsetMembers) {
            fieldsToQuery.add(thisField.getFieldPath());
        }

        String accountQuery = 'SELECT ';
        for (String fieldName : fieldsToQuery){
            accountQuery += fieldName + ',';
        }
        accountQuery = accountQuery.substring(0, accountQuery.length()-1);
        accountQuery += ' FROM Account ';
        accountQuery += ' WHERE Website != NULL ';
        accountQuery += ' ORDER BY Name ASC ';

        return Database.query(accountQuery);
    }

    @AuraEnabled
    public static List<Contact> getContacts(Id accountId){
        //TODO:  Update to use QueryBuilder with setFields
        List<String> fieldsToShow = new List<String>{
            'FirstName',
            'LastName',
            'Email',
            'Phone',
            'Account.Name'
        };

        String contactQuery = 'SELECT Id, ';
        for (String fieldName : fieldsToShow){
            contactQuery += fieldName + ',';
        }
        contactQuery = contactQuery.substring(0, contactQuery.length()-1);
        contactQuery += ' FROM Contact ';
        contactQuery += ' WHERE Email != NULL ';
        contactQuery += ' ORDER BY LastName ASC ';

        return Database.query(contactQuery);
    }
}
