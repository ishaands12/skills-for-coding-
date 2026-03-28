# YouTube Description Template

Use this template to generate YouTube descriptions from video transcripts.

---

## Output Format

Generate the description as a single block of plain text (not markdown) ready to paste into YouTube. Use the exact structure below, filling in sections from the transcript.

```
[HOOK — One punchy sentence. Specific outcome or curiosity gap.]

[CONTEXT — One sentence. Who + what problem.]

In this video, you'll learn:
• [Short takeaway 1]
• [Short takeaway 2]
• [Short takeaway 3]

---

🔗 Want more workflows like this? Join 1,600+ solopreneurs getting practical AI strategies every week:
https://aiwithremy.com

---

🛠️ Links Mentioned
• [Tool/Resource Name]: [URL]
• [Tool/Resource Name]: [URL]

---

📱 Connect With Me
• Newsletter: https://aiwithremy.com
• X/Twitter: https://x.com/remy_gaskell
• LinkedIn: https://www.linkedin.com/in/remygaskell/
• Instagram: https://www.instagram.com/aiwithremy/

---

⏱️ Timestamps
0:00 - [Intro topic]
[TIME] - [Section 1]
[TIME] - [Section 2]
[TIME] - [Section 3]
[TIME] - [Key moment / demo]
[TIME] - [Recap / conclusion]
```

---

## Brand Constants

Update these once — they auto-fill into every description:

- NEWSLETTER_LINK: https://aiwithremy.com
- X_LINK: https://x.com/remy_gaskell
- LINKEDIN_LINK: https://www.linkedin.com/in/remygaskell/
- INSTAGRAM_LINK: https://www.instagram.com/aiwithremy/
- SUBSCRIBER_COUNT: 1,600+
- NEWSLETTER_FREQUENCY: week

> **Note:** Update SUBSCRIBER_COUNT as it grows. Update links if handles change.

---

## Section Guidelines

### Hook
- ONE sentence max. Conversational, not salesy.
- Lead with the outcome or curiosity gap — never "In this video..."
- Good: "I automated my entire content pipeline with one Claude prompt."
- Bad: "Stop wasting hours on tasks AI can do in minutes. Here's exactly how I automated my entire content pipeline using Claude."

### Context
- ONE sentence. Who is this for + what problem it solves. That's it.
- Good: "If you're a solopreneur still doing this stuff manually, this will save you hours."
- Bad: Long multi-sentence explanations of the problem space.

### What You'll Learn
- 3 bullets max (4 only if absolutely necessary)
- Short — each bullet is one line, not a paragraph
- Each starts with an action verb (Build, Automate, Set up, Deploy, etc.)
- Conversational, not formal — write how Remy talks

### Newsletter CTA
- MUST appear early — before YouTube's "show more" truncation (~150 chars on mobile)
- Placed right after "What You'll Learn" to maximize visibility

### Links Mentioned
- Research and find public URLs for tools and resources mentioned in the video
- Ask user for any links that can't be found via web search
- Include ALL tools, platforms, and resources referenced

### Timestamps
- Generated from Whisper transcript segment timestamps
- Identify major topic shifts in the transcript
- Format: M:SS or MM:SS
- First entry always starts at 0:00
- Aim for 5-10 timestamp entries depending on video length

### Tone
- Casual, builder-to-builder
- Honest, anti-hype
- Sounds like Remy, not a corporate channel
