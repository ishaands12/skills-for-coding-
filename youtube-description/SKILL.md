---
name: youtube-description
description: Transcribe a local video file and generate a complete YouTube description. Use when the user provides a video file path and wants a YouTube description, or says youtube description, describe this video, transcribe and describe, write a description for my video, or needs to create YouTube video metadata from a recording. Handles transcription via Whisper, auto-generates timestamps, researches links for tools mentioned, and outputs a paste-ready description. Also triggers on youtube-description install or youtube-description setup to run the install wizard.
---

# YouTube Description Generator

Transcribe a local video file with Whisper, then generate a complete YouTube description with timestamps, links, and brand-consistent copy.

## Install

If the user says `/youtube-description install` or `/youtube-description setup`, run this install wizard instead of the normal workflow. Walk through each step conversationally.

### Step 1: Check Python 3

```bash
python3 --version
```

Need Python 3.8+. If missing or too old:
- **macOS:** `brew install python3`
- **Linux:** `sudo apt install python3 python3-pip`
- **Windows:** Download from python.org

### Step 2: Check pip packages

```bash
pip3 show faster-whisper 2>/dev/null && echo "OK: faster-whisper" || echo "MISSING: faster-whisper"
```

If missing:
```bash
pip3 install faster-whisper
```

**Note:** faster-whisper will download a ~1.5GB Whisper model on first use. This is normal and only happens once.

### Step 3: Check ffmpeg

```bash
which ffmpeg && ffmpeg -version | head -1 || echo "MISSING: ffmpeg"
```

If missing:
- **macOS:** `brew install ffmpeg`
- **Linux:** `sudo apt install ffmpeg`
- **Windows:** Download from ffmpeg.org and add to PATH

### Step 4: Check the humanise-text skill

This skill uses `/humanise-text` to polish the final description copy. Check it's installed:

```bash
ls ~/.claude/skills/humanise-text/SKILL.md 2>/dev/null && echo "OK: humanise-text skill" || echo "MISSING: humanise-text skill"
```

If missing, tell the user: "The `humanise-text` skill is included in this skill pack. Extract it to `~/.claude/skills/humanise-text/` first, then come back and re-run this install."

### Step 5: Verify the transcription script

```bash
python3 -c "from faster_whisper import WhisperModel; print('faster-whisper OK')"
ls <skill_path>/scripts/transcribe.py && echo "OK: transcribe.py"
```

### Step 6: Customize brand constants

Read `<skill_path>/references/youtube-description-template.md` and show the user the Brand Constants section. Ask them to update:
- `NEWSLETTER_LINK` — their newsletter URL
- `X_LINK` — their X/Twitter profile
- `LINKEDIN_LINK` — their LinkedIn profile
- `INSTAGRAM_LINK` — their Instagram profile
- `SUBSCRIBER_COUNT` — their current subscriber count
- `NEWSLETTER_FREQUENCY` — how often they send (e.g., "week", "day")

If the user wants to keep the defaults or skip this, that's fine — they can edit the template file later.

### Step 7: Report status

```
YouTube Description — Install Summary

  Python:         [OK/MISSING] (version)
  faster-whisper: [OK/MISSING]
  ffmpeg:         [OK/MISSING]
  humanise-text:  [OK/MISSING]
  Script:         [OK/MISSING]
  Brand constants: [Customized/Using defaults]
  Status:         [Ready to use / X items need attention]

Try it: /youtube-description then provide a path to a video file.
```

---

## Workflow

1. **Transcribe** — Run `scripts/transcribe.py` on the video file
2. **Read transcript** — Parse the JSON output for text + timestamps
3. **Generate timestamps** — Identify topic shifts → YouTube chapter markers
4. **Research links** — Web search for tools/resources mentioned in the video
5. **Write description** — Fill the template from `references/youtube-description-template.md`
6. **Review with user** — Present the description, ask for any missing links or corrections

## Step 1: Transcribe

Run the transcription script (uses faster-whisper for ~4x speed):

```bash
python3 <skill_path>/scripts/transcribe.py "/path/to/video.mp4"
```

The script outputs:
- `<output_dir>/<filename>.json` — Segments with `start`, `end`, `text`, and `start_formatted` fields
- `<output_dir>/<filename>.txt` — Plain text transcript

Capture the `OUTPUT_DIR` path from the script's output.

**If faster-whisper is not installed**, the script will print installation instructions. Guide the user through:
```bash
pip3 install faster-whisper
brew install ffmpeg  # macOS
```

## Step 2: Read Transcript

Read both output files:
- Read the `.json` file to get timestamped segments (each segment has `start`, `end`, `text`, and `start_formatted` for YouTube-ready timestamps)
- Read the `.txt` file for the full plain-text transcript

## Step 3: Generate Timestamps

From the JSON segments, identify major topic shifts:

1. Scan segments sequentially for content changes (new tool introduced, new concept, demo start, etc.)
2. Group related segments into chapters
3. Use the `start_formatted` field from the first segment in each chapter (already in YouTube M:SS format)
4. First entry is always `0:00`
5. Target 5-10 chapters depending on video length

## Step 4: Research Links

Scan the transcript for mentions of:
- Tools and software (e.g., "Claude", "Cursor", "n8n", "Notion")
- Websites and platforms
- Specific resources, articles, or videos referenced

For each mention:
1. Web search for the official URL
2. If publicly available, add the link directly
3. If unclear or ambiguous, collect and ask the user in Step 6

## Step 5: Write Description

Read `references/youtube-description-template.md` for the template structure and brand constants.

Fill every section from the transcript. **Keep the top sections SHORT and conversational:**

- **Hook**: ONE sentence. Punchy. Specific to this video. Write how Remy talks, not how a marketer writes.
- **Context**: ONE sentence. Who it's for + the problem. That's it.
- **What You'll Learn**: 3 short bullets max. Each one line. Action verb start. Conversational.
- **Newsletter CTA**: Pre-filled from brand constants.
- **Links Mentioned**: All tools/resources with URLs from Step 4.
- **Connect With Me**: Pre-filled from brand constants.
- **Timestamps**: From Step 3.

Output as plain text (not markdown) — ready to paste directly into YouTube.

**Critical:** Do NOT over-write the hook, context, or takeaways. These should feel like casual notes from a friend, not marketing copy. If it sounds like it was written by AI or a copywriter, it's too long and too polished.

After drafting, run the written copy (hook, context, and takeaways) through the `/humanise-text` skill to strip any remaining AI patterns and make it sound natural.

## Step 6: Review

Present the complete description to the user. Ask:
- "Are there any links I couldn't find that you'd like to add?"
- "Any sections you'd like adjusted?"

Make edits as requested, then present the final version.

## Brand Voice Reminders

- Casual, builder-to-builder tone — sounds like Remy, not a corporation
- Anti-hype — honest, no exaggeration
- Specific over generic — concrete outcomes, not vague promises
- Newsletter CTA must appear before YouTube's "show more" truncation
