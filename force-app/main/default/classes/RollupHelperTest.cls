/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 14/09/2021
 * @last modified by  : daniel@hyphen8.com
**/
@isTest
public with sharing class RollupHelperTest {
    
    @IsTest
    static void testAfterInsertMethod(){

        Account account = new Account(Name='DEMO');
        insert account;

        Contact contact = new Contact(LastName='DEMO', AccountId=account.Id);
        insert contact;

        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);
        
        Test.startTest();
            
            ContactRollupHandler crh = new ContactRollupHandler();
            crh.handleAfterInsert(contacts);
            decimal numberOfContacts = [SELECT Number_of_Contacts__c FROM Account WHERE Id=:account.Id LIMIT 1].Number_of_Contacts__c;
            system.assertEquals(1, numberOfContacts, 'Correct number of Contacts');
        
        Test.stopTest();
        
    }

    @IsTest
    static void testAfterDeleteMethod(){

        Account account = new Account(Name='DEMO');
        insert account;

        Contact contact = new Contact(LastName='DEMO', AccountId=account.Id);
        insert contact;

        Contact contact2 = new Contact(LastName='DEMO 2', AccountId=account.Id);
        insert contact2;

        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);
        
        Test.startTest();
            
            ContactRollupHandler crh = new ContactRollupHandler();
            crh.handleAfterInsert(contacts);
            decimal numberOfContacts = [SELECT Number_of_Contacts__c FROM Account WHERE Id=:account.Id LIMIT 1].Number_of_Contacts__c;
            system.assertEquals(2, numberOfContacts, 'Correct number of Contacts');

            delete contact;
            
            ContactRollupHandler crhDelete = new ContactRollupHandler();
            crhDelete.handleAfterDelete(contacts);
            decimal numberOfDeleteContacts = [SELECT Number_of_Contacts__c FROM Account WHERE Id=:account.Id LIMIT 1].Number_of_Contacts__c;
            system.assertEquals(1, numberOfDeleteContacts, 'Correct number of Contacts');

        Test.stopTest();
        
    }
}
