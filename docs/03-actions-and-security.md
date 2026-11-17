# 03 - Actions & Security

## Action design (this repo)

- Apex `@InvocableMethod` actions with plain-English labels/descriptions -
  the reasoning engine routes on these descriptions, so they are written
  like instructions, not code comments.
- Structured Request/Response classes with `@InvocableVariable`
  descriptions stating format and constraints (`format REF-0001`).
- Bulkified signatures (`List<Request>` in, `List<Response>` out).
- `with sharing` everywhere; queries return only fields the agent quotes.
- Every write action creates an `Integration_Log__c` audit row (pattern
  borrowed from the `salesforce-integration-patterns` repo).

## Security checklist for a real org

- [ ] Run the agent as a least-privilege agent user/profile
- [ ] Review Salesforce's trusted/private action guidance before exposing
      any action that reads or writes sensitive records
- [ ] Data-mask or exclude sensitive fields from action outputs
- [ ] Identity verification before showing person-specific data
- [ ] Human escalation path tested end-to-end
- [ ] Conversation logs reviewed (Setup > agent conversation/session data)
- [ ] No real PHI/PII in prompts, summaries, or test data

This demo intentionally shows person-specific data by REF number only as a
teaching example; a production agent would add verification first.
