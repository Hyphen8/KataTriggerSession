/**
 * @description  : 
 * @author       : simon@hyphen8.com
 * @created      : 19/10/2021
**/
@IsTest
public class BatchAnonymiseContactsTest {
    @IsTest
    static void testContactAnonymise(){
        //Set up test data
        List<Contact> contactsBeforeAnonymise = new List<Contact>();

        for (Integer i = 0 ; i < 100 ; i++){
            contactsBeforeAnonymise.add(new Contact(
                FirstName = 'Test_' + i,
                LastName = 'Contact_' + i,
                Email = 'test_' + i + '.contact_' + i + '@myemail_' + i + '.com',
                MobilePhone = '0123456789' + (i < 10 ? '0' + i : ''+i)
            ));
        }

        insert contactsBeforeAnonymise;

        //TODO:
        //Create custom metadata so that we DON'T have to rely on it being in the org using MockMetaManager class
        //Set the mock metadata into the actual class
        //Run the test
        //Assert our tests

    }
}
