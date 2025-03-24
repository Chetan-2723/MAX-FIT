public class TransactionLogHandler {
    public static void doHandleException (system.Exception ex, String processName){
        Error_Log__c transactionLog = new Error_Log__c(
        Log_Details__c = ex.getStackTraceString() + '<br/>' + ex.getMessage() + '<br/>' + ex.getCause() + '<br/>' + ex.getTypeName() + '<br/>' + ex.getLineNumber(),
        Log_DateTime__c = system.Now(),
        Process_Name__c = processName
        );
        insert transactionLog;
    }
    
    public static void doHandleExceptionWithError (String errors, String processName){
        Error_Log__c transactionLog = new Error_Log__c(
        Log_Details__c = errors,
        Log_DateTime__c = system.Now(),
        Process_Name__c = processName
        );
        insert transactionLog;
    }

}