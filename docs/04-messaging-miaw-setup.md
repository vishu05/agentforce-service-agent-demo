# 04 - Messaging (MIAW) Channel Setup

To let external users chat with the agent, connect it to a channel instead
of only testing in Agent Builder:

1. Setup > Messaging Settings - enable **Messaging for In-App and Web**.
2. Create an Embedded Service deployment and a Messaging Channel.
3. In the channel/agent connection, select the **Harborview Support Agent**
   as the agent for the channel (Service Agent channel connection).
4. Publish the Embedded Service code snippet to a test page or an
   Experience Cloud site.
5. Test the full journey: greeting > referral status > support request >
   escalation, and confirm escalations appear for agents in the console.
6. For B2C channels (WhatsApp, Apple Messages for Business, etc.), follow
   the Live Message setup docs linked in the README resources, and review
   each channel's consent/privacy requirements.

Keep the demo on a sandbox/trial site; do not publish fictional support
channels publicly as if they were a real service.
