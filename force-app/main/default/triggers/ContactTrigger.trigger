/**
 * @author       : simon@hyphen8.com
 * @date         : 21-09-2021
**/
trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    (new MetaTriggerManager(Contact.SObjectType).handle());
}