/**
 * @description  : 
 * @author       : simon@hyphen8.com
 * @created      : 12/10/2021
**/
public with sharing class BatchDeleteEmailLogs implements Database.Batchable<SObject>, Schedulable {
    
    private Integer maximumNumberOfRecords = Integer.valueOf(System.Label.Maximum_Number_Of_Logs); //10
    private Integer numberOfRecordsToDelete = Integer.valueOf(System.Label.Number_Of_Logs_To_Delete); //1
    private Integer batchSize = Integer.valueOf(System.Label.Email_logs_delete_Batch_Size); //200

    public Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT ID, (SELECT ID, CreatedDate FROM Email_Logs__r ORDER BY CreatedDate ASC) FROM Account';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> accountList) {
        
        List<Email_Log__c> emailLogsToDelete = new List<Email_Log__c>();
        
        for(Account account : accountList) {
            if(account.Email_Logs__r.size() > maximumNumberOfRecords){
                integer count = 0;
                for(Email_Log__c log:account.Email_Logs__r){
                    if(count < numberOfRecordsToDelete){
                        emailLogsToDelete.add(log);
                    } else {
                        break;
                    }
                    count = count  + 1;
                }
                //Break will come down to here
            }
        }

        delete emailLogsToDelete;
    }
    
    public void finish(Database.BatchableContext BC){
        //maybe do something here.
    }

    public void execute(SchedulableContext SC){
        Database.executeBatch(new BatchDeleteEmailLogs(),batchSize);
    }

}
