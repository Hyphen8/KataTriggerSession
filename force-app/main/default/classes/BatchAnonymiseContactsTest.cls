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

        Account account = new Account(Name='Test Account');
        insert account;

        for (Integer i = 0 ; i < 100 ; i++){
            contactsBeforeAnonymise.add(new Contact(
                FirstName = 'Test_' + i,
                LastName = 'Contact_' + i,
                Email = 'test_' + i + '.contact_' + i + '@myemail.com',
                MobilePhone = '0123456789' + (i < 10 ? '0' + i : ''+i),
                AccountId = account.Id
            ));
        }

        insert contactsBeforeAnonymise;

        List<Data_Anonymisation__mdt> mockMetaData = new MockMetaManager('Data_Anonymisation__mdt')
            .addFieldValue('MasterLabel', 'Contact Email')
            .addFieldValue('DeveloperName', 'Contact_Email')
            .addFieldValue('Data_Type__c','String')
            .addFieldValue('Length_of_Data__c',10)
            .addEntityDefinition('SObject__c','Contact')
            .addFieldDefinition('Field_Name__c','Email')
            .getMockMetaData();


        List<Data_Anonymisation__mdt> allMetaData = new List<Data_Anonymisation__mdt>();
        allMetaData.addAll(mockMetaData);

        test.startTest();
            BatchAnonymiseContacts.mockMetaData = allMetaData;

            ID batchId = Database.executeBatch(new BatchAnonymiseContacts(), 200);

        test.stopTest();

        //TODO:
        //Create custom metadata so that we DON'T have to rely on it being in the org using MockMetaManager class
        //Set the mock metadata into the actual class
        //Run the test
        //Assert our tests

    }
}
