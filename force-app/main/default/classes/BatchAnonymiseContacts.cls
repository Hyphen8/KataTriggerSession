/**
 * @description  : Batchable class to anonymise Contact data
 * @author       : simon@hyphen8.com
 * @created      : 19/10/2021
**/
public without sharing class BatchAnonymiseContacts implements Database.Batchable<SObject>, Schedulable{
    @TestVisible
    private static List<Data_Anonymisation__mdt> mockMetaData;
    private List<Data_Anonymisation__mdt> metaData;
    //WE will need a collection of custom metadata - Data_Anonymisation__mdt

    public BatchAnonymiseContacts(){
        //We have a constructor - this might be helpful when getting the custom metadata / mock metadata...
        if (Test.isRunningTest() && mockMetaData != null){
            metaData = mockMetaData;
        }else {
            metaData = [SELECT SObject__r.QualifiedAPIName, Field_Name__r.QualifiedAPIName, Compound_Field__r.QualifiedAPIName, Data_Type__c, Length_of_Data__c 
                    FROM Data_Anonymisation__mdt
                    WHERE SObject__r.QualifiedAPIName = 'Contact'];
        }
    }

    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        String query = 'SELECT id, ';
        
        //TODO - Key Metadata base on Object name

        //TODO - Refactor for Query Builder

        //TODO - CHECK FOR Compound_Fields
        for(Integer i = 0; i < metadata.Size(); i++){
            Data_Anonymisation__mdt metadataRecord = metaData.get(i);
            if(metadata.size() > i){
                query = query + metadataRecord.Field_Name__r.QualifiedAPIName + ', ';
            }
            else {
                query = query + metadataRecord.Field_Name__r.QualifiedAPIName;
            }
        }
        query = query + ' FROM Contact';
                
        //SCOPE should be ALL Contacts in the org. returning the following fields:
        //FirstName, LastName, Email, MobilePhone
        return Database.getQueryLocator(query); 
    }

    public void execute(Database.BatchableContext batchableContext, List<Contact> scope){
        //TODO - Use Describe info to check valid Field API Name, field length, data type, etc.
        //TODO - Use Describe to check if the data type is email dynamically on the field instead of hard-coding? 
        //EXECUTE Should read custom metadata, anonymise each field, and save the Scope
        //Should also implement Apex Logger for the save
        //There is a helper method available - AnonymiseHelper.generateRandomString(String dataType, Integer len)
        //dataType should be one of 'String', 'Number', 'Mix'

        

        for(Contact con : scope){
            String[] currentEmailSplit = con.Email.split('@');
            //currentEmailSplit[0] = 'test.email'
            //currentEmailSplit[1] = 'myemail.com'
            for(Data_Anonymisation__mdt metadataRecord : metaData) {
                
                String strValue = AnonymiseHelper.generateRandomString(metadataRecord.Data_Type__c, Integer.valueOf(metadataRecord.Length_of_Data__c));
                
                if(metadataRecord.Field_Name__r.QualifiedAPIName == 'Email') {

                    if(metadataRecord.MasterLabel == 'Contact Email') {
                        currentEmailSplit[0] = strValue;
                    }
                    if(metadataRecord.MasterLabel == 'Contact Email Domain') {
                        currentEmailSplit[1] = strValue;
                    }

                    strValue = String.join(currentEmailSplit, '@');
                    
                }
                
                if (metadataRecord.Compound_Field__r.QualifiedApiName != null){
                    con.put(metadataRecord.Compound_Field__r.QualifiedAPIName, strValue);
                }else {
                    con.put(metadataRecord.Field_Name__r.QualifiedAPIName, strValue);
                }
            }            
        }
        update scope;
    }

    public void finish(Database.BatchableContext batchableContext){
        //Nothing to see here.
    }

    //Schedule method
    public void execute(System.SchedulableContext schedulableContext){
        //Can we remember how to implement / call the batchable class here?
    }
}
