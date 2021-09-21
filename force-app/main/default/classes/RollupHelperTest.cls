/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 21/09/2021
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
    static void testAfterUpdateMethod(){
        
        Account account = new Account(Name='DEMO');
        insert account;

        Account newAccount = new Account(Name='DEMO 2');
        insert newAccount;

        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = account.Id
        );

        insert contact;

        account = [
            SELECT Id, Number_of_Contacts__c
            FROM Account
            WHERE Id = :account.Id
        ];

        System.assertEquals(1, account.Number_of_Contacts__c, 'Account is set correctly');

        Test.startTest();

            ContactRollupHandler contactRollupHandler = new ContactRollupHandler();
            List<Contact> oldList = new List<Contact>{contact};
            List<Contact> newList = new List<Contact>{new Contact(
                Id = contact.Id,
                AccountId = newAccount.Id
            )};

            Set<ID> accountIdsChanged = RollupHelper.getAccountIdsChanged(oldList, newList);
            system.assertEquals(2, accountIdsChanged.size(), '2 account ids returned');

            contactRollupHandler.handleAfterUpdate(oldList, newList);

            System.assertEquals(0, [SELECT Id, Number_of_Contacts__c
                FROM Account WHERE Id = :newAccount.Id
            ].Number_of_Contacts__c, 'No change Account');
            System.assertEquals(1, [
                SELECT Id, Number_of_Contacts__c
                FROM Account WHERE Id = :account.Id
            ].Number_of_Contacts__c, 'One Accounts Still');

            contact.AccountId = newAccount.Id;
            update contact;

            RollupHelper.rollupAccount(accountIdsChanged);

        Test.stopTest();

        Account newAccountTest = [
            SELECT Id, Number_of_Contacts__c
            FROM Account WHERE Id = :newAccount.Id
        ];

        Account accountTest = [
            SELECT Id, Number_of_Contacts__c
            FROM Account WHERE Id = :account.Id
        ];

        System.assertEquals(1, newAccountTest.Number_of_Contacts__c, 'Got one Account');
        System.assertEquals(0, accountTest.Number_of_Contacts__c, 'No Accounts Now');
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
