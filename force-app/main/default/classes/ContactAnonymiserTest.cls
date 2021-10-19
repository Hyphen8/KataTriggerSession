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
                    .addEntityParticle('Compound_Field__c',fieldToTest)
                    .getListMockMetaData();

                allMetaData.addAll(fieldMeta);
            }else if ('Email'.equalsIgnoreCase(fieldToTest)){
                List<Data_Anonymisation__mdt> fieldMeta = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest)
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest)
                    .addFieldValue('Data_Type__c','Mix')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getListMockMetaData();

                List<Data_Anonymisation__mdt> fieldMetaDomain = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest + ' Domain')
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest + '_Domain')
                    .addFieldValue('Data_Type__c','Mix')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getListMockMetaData();

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
                    .getListMockMetaData();

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

    @IsTest
    static void testContactAnonymiserMultiple(){
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0 ; i < 100 ; i++){
            contacts.add(new Contact(
                FirstName = 'Test_' + i,
                LastName = 'Contact_'+ i,
                Email = 'test_' + i + '.contact_' + i + '@myemail.com',
                MobilePhone = '0123456789' + (i < 10 ? '0' + i : ''+i)
            ));
        }

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
                    .addEntityParticle('Compound_Field__c',fieldToTest)
                    .getListMockMetaData();

                allMetaData.addAll(fieldMeta);
            }else if ('Email'.equalsIgnoreCase(fieldToTest)){
                List<Data_Anonymisation__mdt> fieldMeta = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest)
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest)
                    .addFieldValue('Data_Type__c','Mix')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getListMockMetaData();

                List<Data_Anonymisation__mdt> fieldMetaDomain = new MockMetaManager('Data_Anonymisation__mdt')
                    .addFieldValue('MasterLabel', 'Contact ' + fieldToTest + ' Domain')
                    .addFieldValue('DeveloperName', 'Contact_'+fieldToTest + '_Domain')
                    .addFieldValue('Data_Type__c','Mix')
                    .addFieldValue('Length_of_Data__c',8)
                    .addEntityDefinition('SObject__c','Contact')
                    .addFieldDefinition('Field_Name__c',fieldToTest)
                    .getListMockMetaData();

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
                    .getListMockMetaData();

                allMetaData.addAll(fieldMeta);
            }
        }

        Test.startTest();

        for (Integer i = 0 ; i < 100 ; i++){
            System.assertEquals(contacts[i].FirstName, 'Test_' + i);
            System.assertEquals(contacts[i].LastName, 'Contact_' + i);
            String emailToCheck = 'test_' + i + '.contact_' + i + '@myemail.com';
            System.assertEquals(contacts[i].Email, emailToCheck);
            String phoneToCheck = '0123456789' + (i < 10 ? '0' + i : ''+i);
            System.assertEquals(contacts[i].MobilePhone, phoneToCheck);
        }
        
        
        for (Contact contact : contacts){
            contact = new ContactAnonymiser(contact, allMetaData)
                .setFields(fieldsToTest)
                .anonymise();
        }
        
        Test.stopTest();

        for (Integer i = 0 ; i < 100 ; i++){
            System.assertNotEquals(contacts[i].FirstName, 'Test_' + i);
            System.assertNotEquals(contacts[i].LastName, 'Contact_' + i);
            String emailToCheck = 'test_' + i + '.contact_' + i + '@myemail.com';
            System.assertNotEquals(contacts[i].Email, emailToCheck);
            String phoneToCheck = '0123456789' + (i < 10 ? '0' + i : ''+i);
            System.assertNotEquals(contacts[i].MobilePhone, phoneToCheck);
        }
    }
}
