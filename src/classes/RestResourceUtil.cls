public class RestResourceUtil {
    public static List<RespWrapper> updateOrSaveLeadRecords(List<LeadWrapper> leads) {
        List<Lead>leadsToInsert = new List<Lead>();

        for (LeadWrapper lead :leads) {
            leadsToInsert.add(
                    new Lead(
                            FirstName = lead.firstname,
                            LastName = lead.lastname,
                            IdExt__c = lead.id,
                            CreatedDateInExtermal__c = lead.createddate,
                            Phone = lead.phone,
                            Street = lead.address.street,
                            City = lead.address.city,
                            PostalCode = lead.address.postalcode,
                            Country = lead.address.country,
                            Company = 'None')
            );
        }

        Database.UpsertResult[] res = Database.upsert(leadsToInsert, Lead.Field.IdExt__c, false);
        List<RespWrapper> respWrappers = new List<RespWrapper>();

        Set<Id> ids = new Set<Id>();
        for (Database.UpsertResult result : res) {
            ids.add(result.id);
        }

        Map<Id, String> leadExids = getLeadExIdsByIds(ids);

        for (Database.UpsertResult upsertResult : res) {
            String msg = Label.Created;
            if (upsertResult.errors.size() > 0) { //isSuccess
                msg = upsertResult.errors[0].message;
            } else if (!upsertResult.created) {
                msg = Label.Updated;
            }

            respWrappers.add(new RespWrapper(leadExids.get(upsertResult.id), upsertResult.success, msg));
        }
        return respWrappers;
    }

    private static Map<Id, String> getLeadExIdsByIds(Set<Id> ids) {
        Map<Id, String> leadExids = new Map<Id, String>();
        for (Lead leadEx : [SELECT Id, IdExt__c FROM Lead WHERE Id IN :ids]) {
            leadExids.put(leadEx.Id, leadEx.IdExt__c);
        }
        return leadExids;
    }


}