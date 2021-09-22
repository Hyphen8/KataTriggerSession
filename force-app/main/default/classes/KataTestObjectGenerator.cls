/**
 * @description  : Extends ApexTools TestObjectGenerator
 * @author       : simon@hyphen8.com
 * @created      : 22/09/2021
**/
public without sharing class KataTestObjectGenerator extends TestObjectGenerator{
    private Account testAccount;
    private Contact testContact;
    private Email_Log__c testEmailLog;

    //TODO: We need methods for Contacts & Email Logs
    //TODO: Do we need to create methods to return Lists, or will single records be sufficient?
    public override Account getAccount(){
        if (null == testAccount){
            testAccount = super.getAccount();
        }
        return testAccount;
    }
}
