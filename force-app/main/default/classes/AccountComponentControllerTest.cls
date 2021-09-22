/**
 * @author       : simon@hyphen8.com
 * @created      : 22/09/2021
**/
@IsTest
public class AccountComponentControllerTest {
    private static Map<Integer, String> indexToLetter = new Map<Integer, String>{
        0 => 'J',
        1 => 'I',
        2 => 'H',
        3 => 'G',
        4 => 'F',
        5 => 'E',
        6 => 'D',
        7 => 'C',
        8 => 'B',
        9 => 'A'
    };
    @IsTest
    static void testGetAccounts(){
        //We use indexToLetter to create the Accounts in reverse alphabetical order to prove that our ORDER BY clause works
        List<Account> accounts = new List<Account>();
        for (Integer i = 0 ; i < 10 ; i++){
            accounts.add(new Account(
                Name = indexToLetter.get(i) + '_Test Account ' + i,
                Website = indexToLetter.get(i) + '_Test Account ' + i + '.org.uk'
            ));
        }
        insert accounts;

        System.assertEquals('J_Test Account 0', accounts[0].Name, 'Inserted in non-sorted order');

        Test.startTest();
        List<Account> accountsFromController = AccountComponentController.getAccounts();

        System.assertEquals(10, accountsFromController.size(), '10 Accounts returned');

        System.assertEquals('A_Test Account 9', accountsFromController[0].Name, 'Sorted successfully');
        Test.stopTest();
    }

    @IsTest
    static void testGetContacts(){
        Account account = new Account(
            Name = 'Test Account'
        );

        insert account;

        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0 ; i < 10 ; i++){
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = indexToLetter.get(i) + '_Contact' + i,
                Email = 'test.' + indexToLetter.get(i) + '_Contact' + i + '@myemail.com',
                AccountId = account.Id
            ));
        }
        insert contacts;
        System.assertEquals('J_Contact0', contacts[0].LastName, 'Inserted in non-sorted order');

        Test.startTest();
        List<Contact> contactsFromController = AccountComponentController.getContacts(account.Id);

        System.assertEquals(10, contactsFromController.size(), '10 Contacts returned');
        System.assertEquals('A_Contact9', contactsFromController[0].LastName, 'Sorted successfully');
        Test.stopTest();

    }
}
