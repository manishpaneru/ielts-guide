# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Running the App

No build step, server, or dependencies required. Open files directly in a browser:

```
open index.html   # landing page
open app.html     # main application
```

The app runs entirely from the filesystem. There is no npm, no bundler, and no transpiler.

## Architecture Overview

**Learn With Trang** is a vanilla JS SPA for IELTS exam preparation. It has no framework, no build tool, and no npm packages — just HTML, CSS, and JS files loaded directly in the browser.

### Entry Points
- [index.html](index.html) — Landing/marketing page
- [app.html](app.html) — Main SPA (all tabs: Dashboard, Mock Test, Practice, Review, Admin)

### JS Load Order (strict — must be preserved in app.html)
```
shared.js → data-*.js → dashboard.js → mock-test.js → practice.js → review.js → admin.js → auth.js
```

### Module Responsibilities
- [js/shared.js](js/shared.js) — Global `appState`, tab navigation, localStorage helpers, toast/modal utilities
- [js/mock-test.js](js/mock-test.js) — Test execution engine: timer, question rendering, scoring, results
- [js/practice.js](js/practice.js) — Practice content rendering and mini quiz logic
- [js/dashboard.js](js/dashboard.js) — Dashboard stats, progress bars, recent history
- [js/review.js](js/review.js) — Canvas-based score trend chart, test history
- [js/admin.js](js/admin.js) — Admin panel UI and CRUD for test/practice content
- [js/auth.js](js/auth.js) — Supabase student authentication
- [js/db.js](js/db.js) — Supabase client wrapper
- [js/data-test.js](js/data-test.js) — Cambridge IELTS 18 Test 1 content
- [js/data-cam18.js](js/data-cam18.js) — Cambridge IELTS 18 Tests 2–4
- [js/data-practice.js](js/data-practice.js) — Practice package content (Beginner/Intermediate/Advanced)

### State Management
All state lives in a single `appState` global object (defined in `shared.js`). There is no reactive framework — UI updates are triggered by calling render functions after state mutations.

### Data Persistence
- **localStorage-first**: all writes go to localStorage immediately for instant feedback
- **Supabase background sync**: data is synced to Supabase non-blocking; graceful degradation if offline
- Key localStorage keys: `ielts_history` (test results, max 50), `hct_admin_data` (admin content overrides)
- Admin content overrides are merged on top of static `data-*.js` content at startup via `loadAdminOverrides()`

### Question Types
Auto-scored: `tfng`, `ynng`, `mcq`, `multi`, `matching`, `matching_headings`, `matching_info`, `short`, `sentence_completion`, `note_completion`, `map_labelling`, `flow_chart`, `table_completion`
Manual review: `writing`, `speaking`

### Band Score Conversion
Raw score percentage thresholds in `mock-test.js` — 97.5% → 9.0 down to <17.5% → 3.5. Same thresholds for all sections.

### Theming
All CSS custom properties (colors, radius, shadows) are defined in [css/shared.css](css/shared.css). The palette is pink/purple kawaii-inspired.

### Admin Panel
- Password: `hct2024` (default, stored/checked via Supabase)
- Admins can edit test packages, questions, audio timestamps, and practice content from the browser
- Admin accounts are filtered out of the student-facing UI
