# 02 - Topics & Instructions (Agent Builder)

Each topic in `Harborview_Support_Agent.agent` maps to a GenAiPlugin topic
(reference copies under `genAiPlugins/`). Good topics follow three rules:

- **Classification description** - one or two sentences on *when* this topic
  applies, written with example phrases a real user would type.
- **Scope** - what the topic WILL do and, just as importantly, WILL NOT do.
- **Instructions** - short, numbered, positive instructions ("Do X"), not
  long negative lists. Put safety rules in the agent-level system prompt
  AND in the topic that writes data.

| Topic | Jobs to be done | Write actions? |
|---|---|---|
| General_FAQ | Programme list, hours, locations | No |
| Referral_Status | Look up REF number, explain status | No (read-only) |
| Create_Support_Request | Capture + confirm + create a request | Yes - confirm first |
| Escalation | Human handoff, complaints, safeguarding | Yes - immediately |

After editing a topic, re-run the sample conversations in
`docs/sample-conversations.md` before reactivating.
