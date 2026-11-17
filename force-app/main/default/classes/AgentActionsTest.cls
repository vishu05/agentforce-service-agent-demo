@isTest
private class AgentActionsTest {

    private static Support_Referral__c seedReferral() {
        Support_Referral__c r = new Support_Referral__c(
            Status__c = 'Open', Programme__c = 'Mentoring',
            Referral_Date__c = Date.today().addDays(-10),
            Requester_Name__c = 'Jamie Example'
        );
        insert r;
        return [SELECT Id, Name FROM Support_Referral__c WHERE Id = :r.Id];
    }

    @isTest
    static void referralStatusFound() {
        Support_Referral__c seeded = seedReferral();
        CheckReferralStatusAction.Request req = new CheckReferralStatusAction.Request();
        req.referralNumber = seeded.Name;

        Test.startTest();
        List<CheckReferralStatusAction.Response> out =
            CheckReferralStatusAction.execute(new List<CheckReferralStatusAction.Request>{ req });
        Test.stopTest();

        System.assertEquals(true, out[0].found);
        System.assertEquals('Open', out[0].status);
        System.assert(out[0].statusSummary.contains(seeded.Name));
    }

    @isTest
    static void referralStatusNotFoundIsGraceful() {
        CheckReferralStatusAction.Request req = new CheckReferralStatusAction.Request();
        req.referralNumber = 'REF-9999';
        List<CheckReferralStatusAction.Response> out =
            CheckReferralStatusAction.execute(new List<CheckReferralStatusAction.Request>{ req });
        System.assertEquals(false, out[0].found);
    }

    @isTest
    static void createsSupportRequestWithAuditLog() {
        CreateSupportRequestAction.Request req = new CreateSupportRequestAction.Request();
        req.category = 'General';
        req.subject = 'Help topping up food assistance';
        req.summary = 'Fictional demo request created by a test.';
        req.requesterName = 'Alex Example';

        Test.startTest();
        List<CreateSupportRequestAction.Response> out =
            CreateSupportRequestAction.execute(new List<CreateSupportRequestAction.Request>{ req });
        Test.stopTest();

        System.assertEquals(true, out[0].created);
        System.assertNotEquals(null, out[0].requestNumber);
        System.assertEquals(1, [SELECT COUNT() FROM Support_Request__c]);
        System.assertEquals(1, [
            SELECT COUNT() FROM Integration_Log__c
            WHERE System_Name__c = 'AgentforceServiceAgent']);
    }

    @isTest
    static void escalationRecorded() {
        EscalateToHumanAction.Request req = new EscalateToHumanAction.Request();
        req.reason = 'User asked for a human';
        req.conversationSummary = 'Fictional demo conversation summary.';
        List<EscalateToHumanAction.Response> out =
            EscalateToHumanAction.execute(new List<EscalateToHumanAction.Request>{ req });
        System.assertEquals(true, out[0].escalated);
        System.assertEquals(1, [
            SELECT COUNT() FROM Support_Request__c WHERE Category__c = 'Escalation']);
    }

    @isTest
    static void bulkActionsStayWithinLimits() {
        List<CreateSupportRequestAction.Request> reqs = new List<CreateSupportRequestAction.Request>();
        for (Integer i = 0; i < 50; i++) {
            CreateSupportRequestAction.Request r = new CreateSupportRequestAction.Request();
            r.category = 'General'; r.subject = 'Bulk demo ' + i; r.summary = 'Bulk test row.';
            reqs.add(r);
        }
        Test.startTest();
        List<CreateSupportRequestAction.Response> out = CreateSupportRequestAction.execute(reqs);
        Test.stopTest();
        System.assertEquals(50, out.size());
        System.assertEquals(50, [SELECT COUNT() FROM Support_Request__c]);
    }
}
