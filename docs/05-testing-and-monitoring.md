# 05 - Testing & Monitoring

## Three layers of testing

1. **Apex unit tests** - `AgentActionsTest` covers every invocable action
   (found/not-found, create + audit log, escalation, bulk).
2. **Agent tests** - `specs/agentTestSpec.yaml` defines utterances with
   expected topic, expected actions, and expected outcome. Create/run via
   Agentforce Testing Center or CLI:
   `sf agent test create --spec specs/agentTestSpec.yaml --target-org <alias>`
   then `sf agent test run --api-name Harborview_Support_Agent_Tests`.
3. **Manual conversation review** - work through
   `docs/sample-conversations.md` in Agent Builder Preview after any
   topic/instruction change.

## What to watch

- Topic misclassification (FAQ questions routed to Create, etc.)
- Hallucinated statuses/dates - agent must only repeat action outputs
- Eligibility or advice overreach - agent must hand these to humans
- Escalation latency - safeguarding utterances must escalate on turn one
- Action audit trail - every write should have an `Integration_Log__c` row

Treat failed utterances as bugs: adjust the topic classification
description or instructions, add the utterance to the test spec, re-run.
