/**
 * @description  : Batchable class to anonymise Contact data
 * @author       : simon@hyphen8.com
 * @created      : 18/10/2021
**/
public without sharing class BatchAnonymiseContacts implements Database.Batchable<SObject>, Schedulable{
    @TestVisible
    private List<Data_Anonymisation__mdt> metaData;
    //WE will need a collection of custom metadata - Data_Anonymisation__mdt

    public BatchAnonymiseContacts(){
        //We have a constructor - this might be helpful when getting the custom metadata / mock metadata...
    }

    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        String query = '';
        //SCOPE should be ALL Contacts in the org. returning the following fields:
        //FirstName, LastName, Email, MobilePhone
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext batchableContext, List<SObject> scope){
        //EXECUTE Should read custom metadata, anonymise each field, and save the Scope
        //Should also implement Apex Logger for the save
        //There is a helper method available - AnonymiseHelper.generateRandomString(String dataType, Integer len)
        //dataType should be one of 'String', 'Number', 'Mix'
    }

    public void finish(Database.BatchableContext batchableContext){
        //Nothing to see here.
    }

    //Schedule method
    public void execute(System.SchedulableContext schedulableContext){
        //Can we remember how to implement / call the batchable class here?
    }
}
