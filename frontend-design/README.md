# frontend-design

Creates production-grade frontend interfaces — React components, HTML/CSS layouts, dashboards, landing pages — with high design quality and real interactivity. Avoids generic AI-generated aesthetics.

## When to use

- Building a UI component that needs to look polished, not like a demo
- Designing a landing page, dashboard, or onboarding flow from scratch
- Translating a Figma design or rough wireframe into working code
- Prototyping a feature quickly without sacrificing visual quality

## What it produces

- React (JSX/TSX) or HTML/CSS/JS depending on context
- Styled with Tailwind CSS or inline styles — specified per request
- Responsive by default, with dark mode support where relevant
- Accessibility-aware (semantic HTML, ARIA where needed)
- Component-level code you can drop into an existing project

## Example prompt

```text
System: [paste SKILL.md contents]

User:
Build a pricing page component for a SaaS product.
- 3 tiers: Starter (free), Pro ($29/mo), Team ($99/mo)
- Each card: feature list, CTA button, "most popular" badge on Pro
- Stack: React + Tailwind CSS
- Style: clean, modern, no gradients — think Linear or Vercel aesthetic
- Must be responsive (stacks vertically on mobile)
```

## Pairs well with

- `figma` — extract design tokens from a Figma file first, then implement
- `excalidraw-diagram-generator` — rough out the layout in Excalidraw before coding
- `web-artifacts-builder` — for multi-component artifacts with routing and state
- `theme-factory` — apply a consistent design system across multiple pages
- `webapp-testing` — write Playwright tests for the component after building
