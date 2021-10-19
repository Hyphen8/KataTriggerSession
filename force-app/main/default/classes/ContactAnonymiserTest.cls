/**
 * @author       : simon@hyphen8.com
 * @created      : 19/10/2021
**/
@IsTest
public class ContactAnonymiserTest {
    @IsTest
    static void testContactAnonymiserSingle(){
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test.contact@myemail.com',
            MobilePhone = '07999999999'
        );

        List<Data_Anonymisation__mdt> allMetaData = new List<Data_Anonymisation__mdt>();
        Set<String> fieldsToTest = new Set<String>{
            'FirstName',
            'LastName',
            'Email',
            'MobilePhone'
        };

        for (String fieldToTest : fieldsToTest){
            if ('FirstName'.equalsIgnoreCase(fieldToTest) || 'LastName'.equalsIgnoreCase(fieldToTest)){
                List<Data_Anonymisation__mdt> fieldMeta = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest)
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest)
                    .addFieldValue('Data_Type__c','String')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Compound_Field__c',fieldToTest)
                    .getMockMetaData();

                allMetaData.addAll(fieldMeta);
            }else if ('Email'.equalsIgnoreCase(fieldToTest)){
                List<Data_Anonymisation__mdt> fieldMeta = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest)
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest)
                    .addFieldValue('Data_Type__c','Mix')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getMockMetaData();

                List<Data_Anonymisation__mdt> fieldMetaDomain = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest + ' Domain')
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest + '_Domain')
                    .addFieldValue('Data_Type__c','Mix')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getMockMetaData();

                allMetaData.addAll(fieldMeta);
                allMetaData.addAll(fieldMetaDomain);

            }else if ('MobilePhone'.equalsIgnoreCase(fieldToTest)){
                List<Data_Anonymisation__mdt> fieldMeta = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest)
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest)
                    .addFieldValue('Data_Type__c','Number')
                    .addFieldValue('Length_of_Data__c',11)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getMockMetaData();

                allMetaData.addAll(fieldMeta);
            }
        }

        Test.startTest();

        System.assertEquals(testContact.FirstName, 'Test');
        System.assertEquals(testContact.LastName, 'Contact');
        System.assertEquals(testContact.Email, 'test.contact@myemail.com');
        System.assertEquals(testContact.MobilePhone, '07999999999');
        
        testContact = new ContactAnonymiser(testContact, allMetaData)
            .setFields(fieldsToTest)
            .anonymise();
        
        Test.stopTest();

        System.assertNotEquals(testContact.FirstName, 'Test');
        System.assertNotEquals(testContact.LastName, 'Contact');
        System.assertNotEquals(testContact.Email, 'test.contact@myemail.com');
        System.assertNotEquals(testContact.MobilePhone, '07999999999');
    }
}
