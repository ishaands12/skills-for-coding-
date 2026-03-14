---
name: escalation
description: Structure high-impact escalation briefs with full technical context, reproduction steps, business impact, and decision clarity. Use when preparing escalations for engineering, product, support, or executive audiences.
---

# Escalation Brief Skill

Structure escalation briefs that communicate the right information to the right people, fast.

## When to Use

- Escalating a critical bug, outage, or incident to leadership
- Preparing a structured escalation for cross-functional stakeholders
- Documenting a customer escalation with business impact
- Packaging a support issue with reproduction steps and context

## Escalation Brief Structure

### 1. Summary (1–2 sentences)
What is happening and why it matters right now.

### 2. Technical Context
- System / component affected
- Error messages, stack traces, or logs
- Environment (prod/staging, region, version)
- Timeline of events

### 3. Reproduction Steps
1. Step-by-step instructions to reproduce the issue
2. Expected behavior vs. actual behavior
3. Frequency: always / intermittent / one-time

### 4. Business Impact
- Who is affected (users, customers, internal teams)
- Severity: P0 (critical) / P1 (high) / P2 (medium) / P3 (low)
- Revenue, SLA, or compliance implications
- Workaround available? (yes/no + description)

### 5. Decision Needed
- What action or decision is required from escalation target
- Deadline or urgency (e.g., "needs resolution before market open")
- Options being considered with tradeoffs

### 6. Owners & Next Steps
| Role | Owner | Action | Due |
|------|-------|--------|-----|
| Primary | @name | Investigate root cause | Now |
| Backup | @name | Customer communication | 1hr |
| Exec Sponsor | @name | Decision on rollback | 2hr |

## Templates

### Engineering Escalation
```
ESCALATION: [Component] — [Brief description]
Severity: P[0–3] | Status: [investigating/mitigating/resolved]

WHAT: [1-sentence description]
IMPACT: [# affected users/requests, revenue exposure]
SINCE: [timestamp]

WHAT WE KNOW: [technical root cause or best hypothesis]
WHAT WE'VE TRIED: [mitigations attempted]
DECISION NEEDED: [specific ask — rollback? hotfix? scale resources?]
```

### Customer Escalation
```
CUSTOMER ESCALATION: [Customer Name]
Priority: [Critical/High/Medium] | ARR: $[amount]

ISSUE: [1-sentence description]
CUSTOMER IMPACT: [what the customer is experiencing]
DURATION: [since when]

TECHNICAL ROOT CAUSE: [if known]
WORKAROUND: [if available]

ASK: [What you need from leadership or team]
TIMELINE: [When decision/action is needed]
```

## Escalation Tier Matrix

| Tier | Trigger | Primary Owner | Backup | SLA |
|------|---------|---------------|--------|-----|
| P0 – Critical | Prod down, data loss | On-call eng | VP Eng | 15 min |
| P1 – High | Major feature broken, >10% users | Team lead | Eng manager | 1 hr |
| P2 – Medium | Degraded performance, workaround exists | IC engineer | Team lead | 4 hr |
| P3 – Low | Minor issue, cosmetic | Assigned IC | — | Next sprint |

## Best Practices

- Lead with impact, not symptoms — executives care about business consequences
- Be explicit about what decision you need, by when
- Keep technical details in an appendix if the audience is non-technical
- One escalation = one clear ask — don't bundle multiple issues
- Update the brief as status changes; timestamp each update

## Post-Escalation Review

After resolution, document:
- Root cause (5 whys)
- Remediation taken
- Preventive actions (owner + deadline)
- SLA/SLO impact
