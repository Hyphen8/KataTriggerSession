/**
 * @description  : Helper class to anonymise passed in Contact
 * @author       : simon@hyphen8.com
 * @created      : 19/10/2021
**/
public without sharing class ContactAnonymiser {
    private List<Data_Anonymisation__mdt> metaDataToUse;
    private Contact contactToUpdate;
    private Set<String> fieldsToUpdate;
    private SObjectIndex metaByObject;
    private SObjectIndex metaByFieldName;
    private SObjectIndex metaByCompoundField;

    public ContactAnonymiser(Contact contact, List<Data_Anonymisation__mdt> metaData) {
        this.contactToUpdate = contact;
        this.metaDataToUse = metaData;
        this.metaByObject = new SObjectIndex('SObject__r.QualifiedApiName')
            .putAll(this.metaDataToUse);

        List<Data_Anonymisation__mdt> allMeta = (List<Data_Anonymisation__mdt>)metaByObject.getAll('Contact');

        this.metaByFieldName = new SObjectIndex('Field_Name__r.QualifiedApiName')
            .putAll(allMeta);
        this.metaByCompoundField = new SObjectIndex('Compound_Field__r.QualifiedApiName')
            .putAll(allMeta);
    }

    public ContactAnonymiser setFields(Set<String> fields){
        this.fieldsToUpdate = fields;
        return this;
    }

    public Contact anonymise(){
        for (String fieldToUpdate : this.fieldsToUpdate){
            if (!'Email'.equalsIgnoreCase(fieldToUpdate)){
                Data_Anonymisation__mdt metaRecord = (Data_Anonymisation__mdt)metaByCompoundField.get(fieldToUpdate);
                if (null == metaRecord){
                    metaRecord = (Data_Anonymisation__mdt)metaByFieldName.get(fieldToUpdate);
                }
                this.contactToUpdate.put(fieldToUpdate, AnonymiseHelper.generateRandomString(metaRecord.Data_Type__c, Integer.valueOf(metaRecord.Length_of_Data__c)));    
            }else {
                List<Data_Anonymisation__mdt> emailMetaData = metaByFieldName.getAll('Email');
                Map<String, String> emailMap = new Map<String, String>();
                for (Data_Anonymisation__mdt emailData : emailMetaData){
                    if ('Contact Email'.equalsIgnoreCase(emailData.MasterLabel)){
                        emailMap.put('Address', AnonymiseHelper.generateRandomString(emailData.Data_Type__c, Integer.valueOf(emailData.Length_of_Data__c)));
                    }else if ('Contact EMail Domain'.equalsIgnoreCase(emailData.MasterLabel)){
                        emailMap.put('Domain', AnonymiseHelper.generateRandomString(emailData.Data_Type__c, Integer.valueOf(emailData.Length_of_Data__c)));
                    }
                }
                String[] emailSplit = this.contactToUpdate.Email.split('@');
                emailSplit[0] = emailMap.get('Address');
                emailSplit[1] = emailMap.get('Domain');
                this.contactToUpdate.Email = String.join(emailSplit, '@');
            }
            
        }

        return this.contactToUpdate;
    }
}
