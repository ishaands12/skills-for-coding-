# Email Template for Lead Magnet Delivery

HTML email template for the n8n Gmail node. This is the exact pattern from the clawdbot-org-chart workflow. Customize the marked sections; keep everything else identical.

## Dynamic Values

| Marker | Replace with |
|--------|-------------|
| `{LEAD_MAGNET_TITLE}` | Full title of the lead magnet |
| `{GREETING_COPY}` | 1-2 sentences thanking them and describing what they got |
| `{DESCRIPTION_COPY}` | 1 sentence describing the value / what it covers |
| `{CTA_COPY}` | Short call-to-action line (e.g. "Open it up and start building:") |
| `{CTA_BUTTON_TEXT}` | Button label (e.g. "Read the Guide", "Get the Checklist") |
| `{NOTION_URL}` | Public Notion doc URL |

## Constant Sections (do not change)

- Logo header (AI with Remy GIF)
- "What's Next" dithered divider
- Newsletter promo paragraph
- Remy's signature image
- All CSS styling

## Full Template

```html
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Your {LEAD_MAGNET_TITLE} Is Ready</title><link href="https://fonts.googleapis.com/css2?family=Space+Mono&display=swap" rel="stylesheet"><style type="text/css">@import url('https://fonts.googleapis.com/css2?family=Space+Mono&display=swap');p,a,td,div,span{word-wrap:break-word;overflow-wrap:break-word;max-width:100%}@media only screen and (max-width:600px){.email-container{width:100%!important;max-width:100%!important}.content-wrapper{padding-left:32px!important;padding-right:32px!important;box-sizing:border-box!important}.logo-img{max-width:200px!important;width:200px!important}}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}</style><!--[if mso]><style type="text/css">body,table,td{font-family:Arial,sans-serif!important;}</style><![endif]--></head><body style="margin:0;padding:0;background-color:#FFFFFF;font-family:Inter,sans-serif;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="margin:0;padding:0;background-color:#FFFFFF;"><tr><td align="center" style="padding:40px 20px;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="550" class="email-container" style="max-width:550px;width:550px;margin:0 auto;background-color:#FFFFFF;table-layout:fixed;overflow:hidden;"><tr><td class="content-wrapper" style="padding:0 24px;overflow:hidden;max-width:100%;box-sizing:border-box;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="table-layout:fixed;width:100%;">

<!-- LOGO (constant) -->
<tr><td align="center" style="padding:0 0 64px 0;"><img src="https://github.com/aiwithremy/ai-with-remy-emails/raw/main/ai-with-remy-logo.gif" alt="AI with Remy" width="240" class="logo-img" style="display:block;max-width:240px;height:auto;border:0;"></td></tr>

<!-- BODY COPY (customize) -->
<tr><td style="padding:0 0 32px 0;"><p style="margin:0 0 16px 0;font-family:Inter,sans-serif;font-size:16px;line-height:1.7;color:#4A4A4A;">{GREETING_COPY}</p><p style="margin:0 0 16px 0;font-family:Inter,sans-serif;font-size:16px;line-height:1.7;color:#4A4A4A;">{DESCRIPTION_COPY}</p><p style="margin:0;font-family:Inter,sans-serif;font-size:16px;line-height:1.7;color:#4A4A4A;">{CTA_COPY}</p></td></tr>

<!-- CTA BUTTON (customize text + URL) -->
<tr><td align="center" style="padding:0 0 32px 0;"><table role="presentation" cellspacing="0" cellpadding="0" border="0"><tr><td align="center" style="background-color:#FFFFFF;border:1px solid #CCCCCC;border-radius:4px;box-shadow:inset -2px -2px 0 0 #E3E3E3;"><a href="{NOTION_URL}" target="_blank" style="display:inline-block;padding:12px 24px;font-family:'Space Mono',monospace;font-size:12px;font-weight:400;color:#121212;text-decoration:none;text-transform:uppercase;letter-spacing:0.02em;">{CTA_BUTTON_TEXT}</a></td></tr></table></td></tr>

<!-- DITHERED DIVIDER + "WHAT'S NEXT" (constant) -->
<tr><td style="padding:48px 0;"><table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"><tr><td style="width:40%;text-align:right;font-family:'Space Mono',monospace;font-size:11px;color:#2A2A2A;letter-spacing:0.05em;overflow:hidden;">&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;</td><td style="padding:0 12px;white-space:nowrap;font-family:'Space Mono',monospace;font-size:11px;letter-spacing:0.05em;color:#AAAAAA;text-transform:uppercase;">WHAT'S NEXT</td><td style="width:40%;text-align:left;font-family:'Space Mono',monospace;font-size:11px;color:#2A2A2A;letter-spacing:0.05em;overflow:hidden;">&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;&#9617;</td></tr></table></td></tr>

<!-- NEWSLETTER PROMO + SIGNOFF (constant) -->
<tr><td style="padding:0 0 48px 0;"><p style="margin:0 0 16px 0;font-family:Inter,sans-serif;font-size:16px;line-height:1.7;color:#4A4A4A;">Every Thursday I send one email with the AI workflows, tools, and news that actually matter. No fluff, no spam.</p><p style="margin:0 0 16px 0;font-family:Inter,sans-serif;font-size:16px;line-height:1.7;color:#4A4A4A;">You're already on the list. First issue lands this week.</p><p style="margin:0 0 16px 0;font-family:Inter,sans-serif;font-size:16px;line-height:1.7;color:#4A4A4A;">Talk Thursday,</p><img src="https://raw.githubusercontent.com/aiwithremy/ai-with-remy-emails/main/remy-signoff.png" alt="Remy" style="display:block;max-width:80px;height:auto;border:0;margin:0;"></td></tr>

</table></td></tr></table></td></tr></table></body></html>
```

## Writing the Email Copy

Match Remy's voice: casual, direct, no corporate speak. Pattern:

- **Greeting**: "Hey! Thanks for grabbing the {title}." (one line)
- **Description**: What it covers and why it's useful. Reference Remy's personal experience. (one line)
- **CTA**: "Open it up and start building:" or similar. (one line)

Keep it short — 3 paragraphs max before the button.
