global class DeleteEventBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){
        String Query= 'select id, Name__c from Event__c where Live__c = true AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext bc, List<Event__C> evt){
        if(!evt.isEmpty()){
            List<Database.DeleteResult> deleteResult= Database.delete(evt);
            for(Database.DeleteResult dr: deleteResult){
                if(!dr.isSuccess()){
                    List<Database.Error> errors= dr.getErrors();
                    String errorInString = String.join(errors,',');
                    transactionLogHandler.doHandleExceptionWithError(errorInString, 'DeleteEventBatch');
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc){
        	Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
        	mail.setSubject('Batch have been processed');
            List<String> toAddress = new List<String>();
            toAddress.add('chetansingh20112000@gmail.com');
            mail.setToAddresses( toAddress );
            mail.setSenderDisplayName('Chetan SFDC');
            
            mail.setHtmlBody('The DeleteEventBatch process have been completed');
        
        	Messaging.SendEmail(new List<Messaging.SingleEmailMessage> {mail});
    }
}