/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 12/10/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   12/10/2021   daniel@hyphen8.com   Initial Version
**/
@isTest
public class BatchDeleteEmailLogsTest {
    
    @isTest 
    static void simpleTest(){

        Account account = new Account(Name='Demo');
        insert account;

        List<Email_Log__c> emailLogs = new List<Email_Log__c>();

        integer noToDelete = Integer.valueOf(System.Label.Number_Of_Logs_To_Delete);
        integer maxNumber = Integer.valueOf(System.Label.Maximum_Number_Of_Logs) + noToDelete + 5;

        for(Integer i = 1; i <= maxNumber; i++){
            Email_Log__c emailLog = new Email_Log__c();
            emailLog.Account__c = account.Id;
            emailLogs.add(emailLog);
        }

        database.insert(emailLogs);

        Test.startTest();
            ID batchProcess = Database.executeBatch(new BatchDeleteEmailLogs(), 1);
        Test.stopTest();

        Integer testNumber = maxNumber - noToDelete;

        System.assertEquals(testNumber, [SELECT COUNT() FROM Email_Log__c], 'Correct Number of Email logs returned');
    }

    @isTest 
    static void testSchedule(){

        Test.startTest();
        String cron_exp = '0 0 0 3 9 ? 2022';

        String jobId = System.schedule('testBasicScheduledApex',cron_exp, new BatchDeleteEmailLogs());
        
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime 
            FROM CronTrigger 
            WHERE Id = :jobId
        ];

        System.assertEquals(cron_exp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        
        Test.stopTest();

    }
}
