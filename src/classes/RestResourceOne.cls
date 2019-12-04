@RestResource(UrlMapping='/createleads/*')
global class RestResourceOne {

    @HttpPut
    global static List<RespWrapper> doPut(List<LeadWrapper> leads) {
        return RestResourceUtil.updateOrSaveLeadRecords(leads);
    }


}