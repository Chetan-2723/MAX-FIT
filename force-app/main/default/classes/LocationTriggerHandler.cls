public class LocationTriggerHandler {
    
    @future(callout=true)
    public static void verifyAddress(string recordId){
        Location__c loc= [Select Id, Name, Verified__c, Street__c, City__c, Postal_Code__c, State__c from Location__c where Id=: recordId];
        
        String baseUrl= 'https://us-street.api.smarty.com/street-address?key=21102174564513388&street='+EncodingUtil.urlEncode(loc.Street__c, 'UTF-8')+'&city='+EncodingUtil.urlEncode(loc.City__c, 'UTF-8')+'&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8')+'&zipcode='+EncodingUtil.urlEncode(loc.Postal_Code__c, 'UTF-8')+'';
       	
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(baseURL);
        httpReq.setHeader('Authorization', 'ApiKey 222109116123809954');
        
        Http http = new Http();
        
        HttpResponse httpRes = new HttpResponse();
        
        try{
            httpRes = http.send(httpReq);
            System.debug(' ResponseBody '+httpRes.getBody());
            if( httpRes.getStatusCode() == 200 && httpRes.getStatus() =='OK'){
                String responseBody = httpRes.getBody();
                if(!String.isBlank(responseBody) && responseBody.length() > 2){
                    loc.Verified__c = true;
                }else{
                    loc.Verified__c = false;
                }
                update loc;
            }else{
                TransactionLogHandler.doHandleExceptionWithError( httpRes.getBody() , 'LocationTriggerHandler');
            }
        }catch(System.CalloutException ex ){
            System.debug(' Exception Executed '+ex.getStackTraceString());
            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler');
        }
    }
}