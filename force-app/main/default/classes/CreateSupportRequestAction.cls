/**
 * @description Agentforce action: create a fictional support request when the
 *              agent cannot resolve an enquiry. Returns the REQ number the
 *              agent quotes back to the user. Write action - the topic must
 *              confirm details with the user before invoking it.
 */
public with sharing class CreateSupportRequestAction {

    public class Request {
        @InvocableVariable(label='Category' required=true
            description='Short category for the request, e.g. Access, Billing, General.')
        public String category;

        @InvocableVariable(label='Subject' required=true
            description='One-line subject summarising what the person needs.')
        public String subject;

        @InvocableVariable(label='Summary' required=true
            description='Two or three sentences describing the request. Never include passwords, payment details, or real personal health information.')
        public String summary;

        @InvocableVariable(label='Requester Name'
            description='Name the person gave for follow-up. Optional.')
        public String requesterName;
    }

    public class Response {
        @InvocableVariable(label='Request Number'
            description='System request number, format REQ-0001, to quote back to the person.')
        public String requestNumber;

        @InvocableVariable(label='Created'
            description='True when the support request was created.')
        public Boolean created;
    }

    @InvocableMethod(
        label='Create Support Request'
        description='Creates a support request for the support team and returns its request number. Use only after the person confirms the category, subject and summary are correct.'
    )
    public static List<Response> execute(List<Request> requests) {
        List<Support_Request__c> toInsert = new List<Support_Request__c>();
        for (Request r : requests) {
            toInsert.add(new Support_Request__c(
                Category__c = r.category,
                Subject__c = r.subject,
                Summary__c = r.summary,
                Status__c = 'New'
            ));
        }
        insert toInsert;
        // Audit trail: every agent write is logged (see salesforce-integration-patterns repo).
        List<Integration_Log__c> logs = new List<Integration_Log__c>();
        for (Support_Request__c rec : toInsert) {
            logs.add(new Integration_Log__c(
                System_Name__c = 'AgentforceServiceAgent',
                Status__c = 'Success',
                Message__c = 'Agent created support request for category: ' + rec.Category__c
            ));
        }
        insert logs;

        List<Support_Request__c> saved = [
            SELECT Id, Name FROM Support_Request__c WHERE Id IN :toInsert
        ];
        Map<Id, String> numberById = new Map<Id, String>();
        for (Support_Request__c rec : saved) { numberById.put(rec.Id, rec.Name); }

        List<Response> results = new List<Response>();
        for (Support_Request__c rec : toInsert) {
            Response out = new Response();
            out.created = true;
            out.requestNumber = numberById.get(rec.Id);
            results.add(out);
        }
        return results;
    }
}
