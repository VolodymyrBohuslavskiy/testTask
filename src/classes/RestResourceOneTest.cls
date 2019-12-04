@IsTest
private class RestResourceOneTest {

private static String requestJSON = [SELECT Body FROM StaticResource WHERE Name = 'RestResourceOne'].Body.toString();

    @IsTest
    static void doPost_positive() {
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestURI = '/services/apexrest/createleads';
        request.requestBody = Blob.valueOf(requestJSON);

        RestContext.request = request;
        RestContext.response = new RestResponse();

        List<LeadWrapper> leadWrappers= (List<LeadWrapper>) JSON.deserialize(requestJSON, List<LeadWrapper>.class);
        List<RespWrapper> respWrappers = RestResourceOne.doPut(leadWrappers);

        System.assertEquals(respWrappers.size(), 2);

    }

    @IsTest
    static void doPost_negative_requiredField() {
        List<LeadWrapper> leadWrappers= (List<LeadWrapper>) JSON.deserialize(requestJSON, List<LeadWrapper>.class);
        leadWrappers[0].lastname=null;
        List<RespWrapper> respWrappers = RestResourceOne.doPut(leadWrappers);
        System.assertEquals(respWrappers.size(), 2);

    }

    @IsTest
    static void doPost_negative_update() {
        List<LeadWrapper> leadWrappers= (List<LeadWrapper>) JSON.deserialize(requestJSON, List<LeadWrapper>.class);
        RestResourceOne.doPut(leadWrappers);
        List<RespWrapper> respWrappers =RestResourceOne.doPut(leadWrappers);
        System.assertEquals(respWrappers.size(), 2);

    }




                }