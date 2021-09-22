/**
 * @author       : simon@hyphen8.com
 * @created      : 22/09/2021
**/
@IsTest
public class AccountSendEmailHandlerTest {
    @IsTest
    static void testAccountUpdateWithLogs(){
        Account account = new Account(
            Name = 'Test Account'
        );
        insert account;

        List<Contact> contacts = new List<Contact>();
        List<Email_Log__c> emailLogs = new List<Email_Log__c>();

        for (Integer i = 0 ; i < 5 ; i++){
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact' + i,
                Email = 'test.contact' + i + '@myemail.com',
                AccountId = account.Id
            ));
            emailLogs.add(new Email_Log__c(
                First_Name__c = 'Test',
                Last_Name__c = 'Contact' + i,
                Email__c = 'test.contact' + i + '@myemail.com',
                Account__c = account.Id
            ));
        }
        //Now create records with same Email address
        for (Integer i = 0 ; i < 5 ; i++){
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'OtherContact' + i,
                Email = 'test.contact' + i + '@myemail.com',
                AccountId = account.Id
            ));
            emailLogs.add(new Email_Log__c(
                First_Name__c = 'Test',
                Last_Name__c = 'OtherContact' + i,
                Email__c = 'test.contact' + i + '@myemail.com',
                Account__c = account.Id
            ));
        }

        insert contacts;
        insert emailLogs;

        Test.startTest();
        AccountSendEmailHandler handler = new AccountSendEmailHandler();
        handler.handleAfterUpdate(new List<Account>{account}, new List<Account>{
            new Account(
                Id = account.Id,
                Send_Latest_Email__c = true
            )
        });
        Test.stopTest();

        emailLogs = [
            SELECT Id, Last_Email_Sent__c
            FROM Email_Log__c
            WHERE Account__c = :account.Id
        ];

        for (Email_Log__c emailLog : emailLogs){
            System.assertEquals(Date.today(), emailLog.Last_Email_Sent__c.date(), 'Correct date sent');
        }
    }
}
