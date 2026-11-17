# 01 - Enable Agentforce (Dev/Trial Org)

> Demo guide for a fictional agent. Use a free Developer Edition or trial
> org with Einstein/Agentforce enabled - never a client or production org.

1. Confirm the org has Einstein Generative AI and Agentforce licences
   (Setup > Einstein Generative AI Setup; Setup > Agentforce Agents).
2. Turn on **Einstein Generative AI** and accept the terms.
3. Turn on **Agentforce** (Setup > Agentforce Agents > Settings).
4. Create/confirm the agent user and permission sets your org provides for
   service agents, following Salesforce's Service Agent setup guide (linked
   in the README resources).
5. Deploy this project: `sf project deploy start --target-org <alias>`.
   The Apex invocable actions must be deployed **before** publishing the agent.
6. Generate or publish the authoring bundle:
   `sf agent publish authoring-bundle --target-org <alias>`
   (or create the agent in Agentforce Builder and retrieve metadata).
7. Open Agentforce Builder, review topics/actions, test in Preview, activate.
