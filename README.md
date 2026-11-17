# Agentforce Service Agent Demo

A complete, source-controlled blueprint for an **Agentforce Service Agent**:
an Agent Script (`.agent`) definition with 4 topics, three Apex invocable
actions, an agent test spec, and a step-by-step implementation playbook -
for a fictional community-support organisation.

> Portfolio demo. "Harborview Community Services", its programmes, people
> and data are fictional. Built from scratch; contains no code, data or
> configuration from any employer or client. Requires an Agentforce-enabled
> org (Developer/trial) to run - see caveats below.

## The Scenario

Visitors to Harborview's support site ask the same three things: general
questions, "where is my referral?", and "I need help". The agent handles
the first two end-to-end (read-only status lookup), captures the third as a
confirmed support request, and escalates instantly for humans, complaints,
emergencies and safeguarding concerns.

## Topics & Actions

| Topic | What it does | Action (Apex) | Type |
|---|---|---|---|
| General FAQ | Programmes, hours, locations from fixed demo facts | - | Instructions only |
| Check Referral Status | Looks up a REF number, explains its status | `CheckReferralStatusAction` | Read |
| Create Support Request | Confirms details, creates a request, quotes REQ number | `CreateSupportRequestAction` | Write (+ audit log) |
| Escalate To Human | Records escalation + follow-up message | `EscalateToHumanAction` | Write (+ audit log) |

## What's Inside

```
force-app/main/default/
  aiAuthoringBundles/Harborview_Support_Agent/
    Harborview_Support_Agent.agent          <- Agent Script: topics, routing, guardrails
    Harborview_Support_Agent.bundle-meta.xml
  classes/
    CheckReferralStatusAction.cls           <- @InvocableMethod agent actions
    CreateSupportRequestAction.cls
    EscalateToHumanAction.cls
    AgentActionsTest.cls                    <- Apex tests for every action
  genAiPlugins/                             <- Classic topic metadata (reference copies)
  genAiFunctions/                           <- Classic action metadata + input/output schemas
  objects/ Support_Referral__c, Support_Request__c, Integration_Log__c
specs/agentTestSpec.yaml                    <- Agent-level tests (topic/action/outcome)
docs/
  01-enable-agentforce.md                   <- Setup walkthrough (replaces video notes)
  02-agent-builder-topics.md
  03-actions-and-security.md
  04-messaging-miaw-setup.md
  05-testing-and-monitoring.md
  sample-conversations.md                   <- 10 judged conversations incl. abuse cases
```

## How It Fits Together

```
User message
  -> topic_selector (Agent Script routing)
  -> topic reasoning + guardrail instructions
  -> Apex invocable action (bulkified, with sharing, audited)
  -> Integration_Log__c audit row for every write
```

Design choices worth noticing: routing decisions come from action/topic
*descriptions* written for the reasoning engine; the status topic may only
repeat action output (anti-hallucination rule); the write topic must confirm
before creating; escalation bypasses all other flows on turn one.

## Getting Started (Agentforce org required)

```bash
sf org login web --alias agentforce-dev
sf project deploy start --target-org agentforce-dev   # objects + Apex actions first
sf agent publish authoring-bundle --target-org agentforce-dev
sf agent test create --spec specs/agentTestSpec.yaml --target-org agentforce-dev
```

Then test in Agent Builder Preview with `docs/sample-conversations.md`,
and connect a Messaging (MIAW) channel per `docs/04-messaging-miaw-setup.md`.

## Honest Caveats

- Agentforce needs Einstein/Agentforce licences; this will **not** run in a
  plain Developer Edition org without them.
- The `.agent` script is authored to the published Agent Script format and
  the classic GenAi metadata is included as reference; on first publish,
  let `sf agent publish` generate/validate downstream metadata in your org
  and commit what it retrieves.
- Apex actions are unit-tested here but, like the rest of this portfolio,
  have not been executed in a live org yet.

## Resources (official Salesforce docs)

Curated starting points - the same learning path Salesforce publishes,
organised the way this demo is built:

- [Topic instructions best practices](https://help.salesforce.com/s/articleView?id=sf.copilot_topics_instructions.htm&type=5)
- [Action instructions best practices](https://help.salesforce.com/s/articleView?id=sf.copilot_actions_instructions.htm&type=5)
- [Service Agent setup](https://help.salesforce.com/s/articleView?id=service.service_agent_setup.htm&type=5)
- [Connect a Service Agent to channels](https://help.salesforce.com/s/articleView?id=service.agent_setup_channels.htm&type=5)
- [Service Agent security guidelines](https://help.salesforce.com/s/articleView?id=service.service_agentforce_trusted_private_actions.htm&type=5)
- [Messaging for In-App and Web setup](https://help.salesforce.com/s/articleView?id=service.miaw_setup_stages.htm&type=5)
- [MIAW REST APIs](https://developer.salesforce.com/docs/service/messaging-api/guide/get-started.html)
- [Messaging SDKs](https://developer.salesforce.com/developer-centers/service-sdk)
- [Agentforce workshop (service agents)](https://developer.salesforce.com/agentforce-workshop/service-agents/overview)
- [Agentforce Service Agent Quick Look (Trailhead)](https://trailhead.salesforce.com/content/learn/modules/agentforce-service-agent-quick-look/get-started-with-agentforce-service-agent)

## Related Portfolio Repos

- `salesforce-referral-history-lwc` - the referral domain behind the status action
- `salesforce-integration-patterns` - the logging/retry patterns used for auditing
- `salesforce-intake-wizard-demo` - the human-driven version of this intake flow

## License

MIT - see [LICENSE](LICENSE).
