/**
 * @description Agentforce action: record an escalation so a human support
 *              worker picks up the conversation. In a real org this would
 *              hand off to Omni-Channel / Messaging for In-App and Web;
 *              here it creates a priority support request and logs the reason.
 */
public with sharing class EscalateToHumanAction {

    public class Request {
        @InvocableVariable(label='Reason' required=true
            description='Why the conversation is being escalated, e.g. user asked for a human, complaint, safeguarding concern, or agent could not help.')
        public String reason;

        @InvocableVariable(label='Conversation Summary' required=true
            description='Brief factual summary of the conversation so far, without sensitive personal details beyond what is needed for follow-up.')
        public String conversationSummary;
    }

    public class Response {
        @InvocableVariable(label='Escalated'
            description='True when the escalation was recorded.')
        public Boolean escalated;

        @InvocableVariable(label='Message To User'
            description='Message the agent should share with the person about what happens next.')
        public String messageToUser;
    }

    @InvocableMethod(
        label='Escalate To Human'
        description='Records an escalation for a human support worker and returns the message to share with the person. Use immediately for safeguarding concerns, complaints, or whenever the person asks for a human.'
    )
    public static List<Response> execute(List<Request> requests) {
        List<Support_Request__c> escalations = new List<Support_Request__c>();
        List<Integration_Log__c> logs = new List<Integration_Log__c>();
        for (Request r : requests) {
            escalations.add(new Support_Request__c(
                Category__c = 'Escalation',
                Subject__c = 'Agent escalation: ' + (r.reason == null ? 'Unspecified' : r.reason.left(60)),
                Summary__c = r.conversationSummary,
                Status__c = 'New'
            ));
            logs.add(new Integration_Log__c(
                System_Name__c = 'AgentforceServiceAgent',
                Status__c = 'Escalated',
                Message__c = 'Escalation reason: ' + r.reason
            ));
        }
        insert escalations;
        insert logs;

        List<Response> results = new List<Response>();
        for (Integer i = 0; i < requests.size(); i++) {
            Response out = new Response();
            out.escalated = true;
            out.messageToUser = 'I have passed this to a support worker who will follow up. '
                + 'If you need urgent help, please contact your local support line directly.';
            results.add(out);
        }
        return results;
    }
}
