/**
 * @description Agentforce action: look up a fictional support referral by
 *              its number (e.g. REF-0003) and return a plain-language status.
 *              Invoked by the Referral_Status topic. Read-only.
 */
public with sharing class CheckReferralStatusAction {

    public class Request {
        @InvocableVariable(label='Referral Number' required=true
            description='Referral number exactly as given to the requester, format REF-0001.')
        public String referralNumber;
    }

    public class Response {
        @InvocableVariable(label='Found'
            description='True when a matching referral exists.')
        public Boolean found;

        @InvocableVariable(label='Status Summary'
            description='Plain-language summary of the referral status for the requester.')
        public String statusSummary;

        @InvocableVariable(label='Referral Status'
            description='Raw status value of the referral, e.g. Open or Closed.')
        public String status;

        @InvocableVariable(label='Programme'
            description='Programme the referral belongs to, e.g. Mentoring.')
        public String programme;
    }

    @InvocableMethod(
        label='Check Referral Status'
        description='Finds a support referral by referral number and returns its current status and programme. Use when someone asks where their referral is or what is happening with it.'
    )
    public static List<Response> execute(List<Request> requests) {
        List<Response> results = new List<Response>();
        Set<String> numbers = new Set<String>();
        for (Request r : requests) {
            if (String.isNotBlank(r.referralNumber)) {
                numbers.add(r.referralNumber.trim().toUpperCase());
            }
        }
        Map<String, Support_Referral__c> byNumber = new Map<String, Support_Referral__c>();
        for (Support_Referral__c rec : [
            SELECT Id, Name, Status__c, Programme__c, Referral_Date__c
            FROM Support_Referral__c WHERE Name IN :numbers
        ]) {
            byNumber.put(rec.Name.toUpperCase(), rec);
        }
        for (Request r : requests) {
            Response out = new Response();
            Support_Referral__c rec = (r.referralNumber == null)
                ? null : byNumber.get(r.referralNumber.trim().toUpperCase());
            if (rec == null) {
                out.found = false;
                out.statusSummary = 'I could not find a referral with that number. '
                    + 'Please check the number and try again, or I can connect you with a support worker.';
            } else {
                out.found = true;
                out.status = rec.Status__c;
                out.programme = rec.Programme__c;
                out.statusSummary = 'Referral ' + rec.Name + ' (' +
                    (String.isBlank(rec.Programme__c) ? 'General support' : rec.Programme__c) +
                    ') is currently "' + rec.Status__c + '".';
            }
            results.add(out);
        }
        return results;
    }
}
