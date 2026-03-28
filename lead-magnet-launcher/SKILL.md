---
name: lead-magnet-launcher
description: "Create a full lead magnet funnel from a Notion doc URL. Builds the landing page, access/thank-you page, deploys an n8n email delivery workflow via MCP, and wires up vercel.json routes + subscribe.js. Use when the user says 'new lead magnet', 'lead magnet page', 'spin up a lead magnet', provides a Notion URL with intent to create a landing page + email funnel, or mentions IG reel CTAs like 'comment X and get my free Y'. Also triggers on 'lead-magnet-launcher install' or 'lead-magnet-launcher setup' to run the install wizard."
---

# Lead Magnet Launcher

Spin up a complete lead magnet funnel from a single Notion doc URL. The Notion doc IS the deliverable — the thing people receive after signing up.

## Install

If the user says `/lead-magnet-launcher install` or `/lead-magnet-launcher setup`, run this install wizard instead of the normal workflow. Walk through each step conversationally — check, explain, guide, move on.

This skill orchestrates several services together. The install wizard checks each one is set up and walks the user through anything that's missing. The specific tools below are what the original author uses — adapt to your own stack where needed.

### Step 1: Check Notion MCP

This skill reads Notion pages to extract content for the lead magnet. You need the Notion MCP server connected to Claude Code.

**Check:** Ask Claude to list available MCP tools and look for `mcp__notion__` or `mcp__claude_ai_Notion__` prefixed tools.

**If missing:** Walk the user through setting up Notion access:
1. Go to Settings in Claude Code
2. Add the Notion MCP server (either the official Claude Notion integration or the community Notion MCP server)
3. Connect it to their Notion workspace
4. Verify by running a simple search: use the Notion search tool to find a test page

**Why it's needed:** The skill reads Notion doc content to auto-generate landing page copy and links the access page to the Notion deliverable.

### Step 2: Check n8n MCP (Email Automation)

This skill creates an automated email delivery workflow. The original uses n8n (open-source automation) with a Gmail node to send the lead magnet via email when someone signs up.

**Check:** Look for `mcp__n8n-workflow-builder__` prefixed tools.

**If missing:** Walk the user through the options:

**Option A: n8n (recommended — what this skill is built for)**
1. Self-host n8n or use n8n Cloud (n8n.io)
2. Install the n8n MCP server for Claude Code: search for `n8n-workflow-builder` MCP
3. Connect it to your n8n instance
4. Verify: run `mcp__n8n-workflow-builder__n8n_health_check`

**Option B: Alternative email automation**
The user can adapt the pattern to any automation tool:
- Zapier (webhook trigger → email action)
- Make.com (webhook trigger → email action)
- Direct API (e.g., SendGrid, Resend, Postmark API call from their serverless function)

If going with an alternative, the user will need to manually handle the email delivery step instead of having Claude auto-create the workflow. The rest of the skill (landing page, access page, routes) still works.

### Step 3: Check email sending credentials

The n8n workflow uses Gmail OAuth to send the delivery email. The user needs email credentials set up in their automation tool.

**If using n8n:**
1. In n8n, go to Credentials → Add New → Gmail OAuth2
2. Follow n8n's Gmail OAuth setup guide
3. Test by sending a test email from n8n

**If using an alternative:**
- Set up API keys for their email provider (SendGrid, Resend, etc.)
- Ensure they can programmatically send transactional emails

### Step 4: Check hosting/deployment

The skill creates static HTML pages and assumes a deployment setup with URL rewrites (clean URLs like `/my-guide` instead of `/lead-magnets/my-guide/index.html`).

**Check:** Ask the user what hosting they use.

**If Vercel (original setup):**
1. Check Vercel CLI: `npx vercel --version`
2. If missing: `npm i -g vercel`
3. Link project: `npx vercel link`
4. The skill will auto-update `vercel.json` with rewrite rules

**If Netlify:**
- The skill can create `_redirects` entries instead of `vercel.json` rewrites
- Pattern: `/my-guide  /lead-magnets/my-guide/index.html  200`

**If other hosting:**
- The user needs to configure URL rewrites/redirects manually
- The skill will tell them what routes to set up

### Step 5: Check newsletter/subscriber API

The landing page form submits to a subscribe API endpoint that adds the visitor to a newsletter list AND triggers the email delivery. The original uses Beehiiv as the newsletter platform.

**Ask the user:** "What newsletter platform do you use? (Beehiiv, ConvertKit, Mailchimp, etc.)"

**If Beehiiv (original):**
1. Get API key from Beehiiv dashboard → Settings → API
2. Get Publication ID from Beehiiv dashboard
3. These go into environment variables on the hosting platform

**If ConvertKit/Mailchimp/other:**
- The user will need to adapt the `subscribe.js` API endpoint to use their platform's API
- The pattern is the same: form POST → add subscriber → trigger email delivery webhook

### Step 6: Check project structure

The skill expects a project directory with:
```
your-project/
├── lead-magnets/          (where new lead magnet pages go)
├── vercel.json            (or equivalent routing config)
├── api/subscribe.js       (serverless function for form submissions)
└── styles.css             (shared stylesheet — optional but recommended)
```

**Check:** Look for these files in the current project directory.

**If the project structure doesn't exist yet:**
Walk the user through creating the minimal structure. The skill includes an HTML email template in `references/email-template.md` that can be adapted.

### Step 7: Report status

```
Lead Magnet Launcher — Install Summary

  Notion MCP:       [OK/MISSING] — Read lead magnet content from Notion
  Email automation:  [OK/MISSING] — n8n / alternative for delivery emails
  Email credentials: [OK/MISSING] — Gmail OAuth / API key for sending
  Hosting:           [OK/MISSING] — Vercel / Netlify / other
  Newsletter API:    [OK/MISSING] — Beehiiv / ConvertKit / other
  Project structure: [OK/MISSING] — lead-magnets dir, routes config, subscribe API
  Status:            [Ready to use / X items need attention]

How it works:
  1. You give it a Notion doc URL
  2. It reads the doc, generates landing + access pages
  3. Creates an email automation to deliver the doc on signup
  4. Wires up routes and subscriber API
  5. You deploy — done

Try it: /lead-magnet-launcher https://notion.so/your-page
```

If anything is missing, summarize what still needs setting up and offer to help with each item.

---

## Workflow

### Step 1: Gather Context

1. Accept the Notion doc URL from the user
2. Use the Notion MCP tools to read the page:
   - Load `mcp__notion__API-retrieve-a-page` to get the page title and properties
   - Load `mcp__notion__API-get-block-children` to read the page content for a summary
3. Extract from the Notion page: **title**, **summary** (first ~2 sentences of content)
4. Determine the **public Notion URL** (the shareable link the user provides)
5. Ask the user for the missing pieces using AskUserQuestion:
   - **Slug** (kebab-case, e.g. `clawdbot-org-chart`) — suggest one from the title
   - **Headline** — suggest one derived from the title
   - **Subheadline** — suggest a 1-2 sentence value prop from the content
   - **Eyebrow badge text** (e.g. "Free guide", "Free checklist") — suggest based on content type
   - **CTA button text** for the landing page (e.g. "Get the Guide", "Get the Checklist")

### Step 2: Read Existing Templates

Read these files from the website-team project to use as living templates:

```
lead-magnets/clawdbot-org-chart/index.html          → Landing page template
lead-magnets/clawdbot-org-chart/access/index.html    → Access page template
.claude/CLAUDE.md                                     → Design system context
.claude/Knowledge/BRAND-GUIDELINES.md                 → Brand tokens (if exists)
```

The clawdbot-org-chart pages are the canonical reference. Match their structure exactly.

### Step 3: Create Landing Page

Create `lead-magnets/{slug}/index.html`:

- Copy the **exact structure** of `clawdbot-org-chart/index.html`
- Replace these dynamic values:

| Element | What to change |
|---------|---------------|
| `<title>` | `{Headline} \| AI with Remy` |
| `<meta name="description">` | Subheadline text |
| `og:title`, `og:description` | Headline and subheadline |
| `.leadmagnet-hero__eyebrow` | Eyebrow badge text |
| `.leadmagnet-hero__headline` | Headline (use `<br>` for line breaks) |
| `.leadmagnet-hero__subhead` | Subheadline |
| `data-leadmagnet-form` action | Keep as-is (uses `/api/subscribe`) |
| `leadmagnet:` in JS body | `'{slug}'` |
| `window.location.href` in JS | `'/{slug}/access'` |
| Button text | CTA button text |
| `.leadmagnet-hero__transparency` | Keep the newsletter transparency line as-is |

- Keep **all CSS, JS, footer, animation patterns, and form logic** identical
- Keep the blurred document preview section (it's the same for all guide-type lead magnets)

### Step 4: Create Access Page

Create `lead-magnets/{slug}/access/index.html`:

- Copy the **exact structure** of `clawdbot-org-chart/access/index.html`
- Replace these dynamic values:

| Element | What to change |
|---------|---------------|
| `<title>` | `Your {Resource Type} Is Ready \| AI with Remy` |
| `<meta name="description">` | Access description |
| `og:title`, `og:description` | Access page title and description |
| `.watch-hero__headline` | "Your guide is ready" (or appropriate variant) |
| `.watch-hero__subhead` | "We've emailed you the full guide. Or just open it right now:" |
| `.btn--guide` href | The public Notion doc URL |
| `.btn--guide` text | "Read the Guide" (or appropriate variant) |

- Keep `<meta name="robots" content="noindex, nofollow">` — access pages should not be indexed
- Keep the newsletter callout section, badge, footer, and animations identical

### Step 5: Deploy n8n Email Workflow

1. Read an existing `lead-magnets/*/n8n-automation.json` for the HTML email template structure
2. Customize the email template:
   - Replace the subject line
   - Replace the greeting and description copy
   - Replace the CTA button text and Notion URL
   - **CTA button must be left-aligned** (`align="left"` on the outer `<td>` wrapping the button table)
   - Newsletter section copy: "Every Thursday I send one email with the AI workflows, tools, and playbooks I use to stay lean and move fast." then "You're already on the list." then "Talk Thursday,"
   - Keep the "What's Next" dithered dividers and Remy's signature as-is
3. Use `mcp__n8n-mcp__n8n_create_workflow` to create the workflow:

```json
{
  "name": "{Title} Email Delivery",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "{slug}-signup",
        "options": {}
      },
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 2,
      "position": [-48, 256],
      "webhookId": "{slug}-signup"
    },
    {
      "parameters": {
        "sendTo": "={{ $json.body.email }}",
        "subject": "Your {Title} Is Ready",
        "emailType": "html",
        "message": "<FULL_EMAIL_HTML_FROM_TEMPLATE>",
        "options": { "appendAttributionToBody": false }
      },
      "name": "Send a message",
      "type": "n8n-nodes-base.gmail",
      "typeVersion": 2.2,
      "position": [160, 256],
      "credentials": {
        "gmailOAuth2": {
          "id": "xbD2RIu6yNNYIkq4",
          "name": "Gmail account"
        }
      }
    }
  ],
  "connections": {
    "Webhook": {
      "main": [[{ "node": "Send a message", "type": "main", "index": 0 }]]
    }
  },
  "settings": { "executionOrder": "v1" }
}
```

4. Save the workflow JSON locally at `lead-magnets/{slug}/n8n-automation.json`

5. **Extract the webhook URL:**
   - Use `mcp__n8n-mcp__n8n_get_workflow` with the workflow ID returned from creation
   - Derive the n8n base URL: read the existing `N8N_WEBHOOK_URL` env var via `vercel env pull` or check `mcp__n8n-mcp__n8n_health_check` for the instance URL
   - The production webhook URL follows the pattern: `{n8n_base_url}/webhook/{slug}-signup`
   - Store this URL — it's needed for Step 8

6. **Activate the workflow:**
   - Use `mcp__n8n-mcp__n8n_update_partial_workflow` to set `active: true`
   - Production webhooks only work when the workflow is active

7. **Move to Lead Magnets folder:**
   - All lead magnet delivery workflows should be placed in the "Lead Magnets" folder in n8n
   - Use the n8n API or UI to move the workflow after creation

### Step 6: Update vercel.json

Add two rewrite rules to the `rewrites` array in `vercel.json`:

```json
{ "source": "/{slug}", "destination": "/lead-magnets/{slug}" },
{ "source": "/{slug}/access", "destination": "/lead-magnets/{slug}/access" }
```

### Step 7: Update subscribe.js

Add a new webhook trigger block in `api/subscribe.js`, inside the `if (response.ok)` block, **before** `return res.status(200)`. Follow this pattern:

```javascript
// Trigger n8n {title} email workflow (await to prevent Vercel from killing the function)
const N8N_WEBHOOK_URL_{SLUG_SCREAMING} = process.env.N8N_WEBHOOK_URL_{SLUG_SCREAMING};
if (N8N_WEBHOOK_URL_{SLUG_SCREAMING} && req.body.leadmagnet === '{slug}') {
  try {
    await fetch(N8N_WEBHOOK_URL_{SLUG_SCREAMING}, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email })
    });
  } catch (err) {
    console.error('n8n webhook error:', err);
  }
}
```

**CRITICAL:** Must use `await fetch()` — NOT fire-and-forget. Vercel kills the serverless function after `res.json()` returns, so unawaited fetch calls never complete.

Where `{SLUG_SCREAMING}` is the slug in SCREAMING_SNAKE_CASE (e.g. `clawdbot-org-chart` → `CLAWDBOT_ORG_CHART`).

### Step 8: Set Vercel Environment Variable

**IMPORTANT:** Do NOT create a new Vercel project. The site is already deployed via the existing `ai-with-remy-landing` project linked to the GitHub repo. Always link to it first:

```bash
npx vercel link --project ai-with-remy-landing --yes
```

Then set the env var:

```bash
printf "{webhook_url}" | npx vercel env add N8N_WEBHOOK_URL_{SLUG_SCREAMING} production
```

Where `{webhook_url}` is the production webhook URL extracted in Step 5.

If `vercel` CLI is not available or not linked, fall back to telling the user to set it manually in the Vercel dashboard and provide the exact key/value pair.

### Step 9: Verify End-to-End

Run these checks before declaring done:

1. **Test n8n workflow:**
   - Use `mcp__n8n-mcp__n8n_test_workflow` with the workflow ID
   - Pass test payload: `{ "body": { "email": "remy@aiwithremy.com" } }`
   - Confirm the workflow executes successfully (check execution status)
   - Ask the user to verify the test email arrived with the correct Notion link

2. **Verify Beehiiv wiring:**
   - Confirm `subscribe.js` has the new leadmagnet slug check
   - Confirm the env var name matches between `subscribe.js` and the Vercel env var set in Step 8

3. **Verify routes:**
   - Confirm `vercel.json` has both `/{slug}` and `/{slug}/access` rewrites
   - Confirm the landing page form JS uses `leadmagnet: '{slug}'` and redirects to `'/{slug}/access'`
   - Confirm the access page CTA button href points to the correct Notion URL

4. **Cross-check file consistency:**
   - The slug in the landing page JS matches the slug in `subscribe.js`
   - The Notion URL in the access page matches the Notion URL in the n8n email template
   - The email subject line is consistent with the access page headline

### Step 10: Summary

Present to the user:

1. **Files created:**
   - `lead-magnets/{slug}/index.html` — Landing page
   - `lead-magnets/{slug}/access/index.html` — Access page
   - `lead-magnets/{slug}/n8n-automation.json` — Workflow backup

2. **Files modified:**
   - `vercel.json` — Added routes `/{slug}` and `/{slug}/access`
   - `api/subscribe.js` — Added webhook trigger for `{slug}`

3. **n8n workflow:** Deployed and active — show workflow name and webhook URL

4. **Vercel env var:** `N8N_WEBHOOK_URL_{SLUG_SCREAMING}` set to production

5. **Verification results:** Show pass/fail for each check from Step 9

6. **To go live:** Deploy to Vercel (offer to run `/deploy` if the Vercel skill is available)
