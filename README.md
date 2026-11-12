# Campus Compass — LPU Career Intelligence

**Find your direction. Build your future.** A browser-based placement and career-preparation hub for LPU students.

## What is included in this build

- Refreshed UI with page transitions, card hover motion, focus states, responsive layouts and reduced-motion support.
- Home dashboard with recruiter snapshot, placement metrics, recent interview activity, student community feed and a company-name ticker that moves right-to-left at the bottom of the home page only.
- Expanded company directory with stream filters and company profiles.
- Senior guidance section with additional named sample student profiles. These names are explicitly marked as illustrative demo identities, not real testimonials or claims that those people supplied the advice. Existing guidance is retained.
- Expanded preparation library with separate categories for DSA, programming languages, core CS, web development, cybersecurity, cloud/DevOps, data/AI, communication, aptitude, interview preparation, projects, tools/Git and design/domain skills.
- Student contribution form that records the contributor's display name and course/batch. Community posts are labelled unverified until reviewed.
- A student profile, private roadmap choice and progress checklist, backed by account authentication after Supabase setup.
- Roadmap links to the matching `roadmap.sh` pages.
- A dedicated LPU placements page with published placement metrics and selected student success stories linked back to LPU's official pages.

## Open the project without running commands

1. Download and extract the ZIP.
2. Open the `campus-compass-lpu` folder.
3. Double-click `index.html`.

No terminal, npm installation or local server is required for the browser preview.

## Student accounts, private data and public contributions

This version includes Supabase Auth wiring for email/password registration, sign-in, email verification, password reset and persistent sessions. Student profile details and roadmap progress are stored in private account-owned tables with row-level security. A signed-in student can publish interview experiences, company additions, senior guidance and preparation resources; those published contributions are readable by all visitors. Public contribution records do not include the student's email address.

**The backend must be activated before real accounts work.** This ZIP cannot connect to your Supabase project until its publishable/anon key is added to `config.js` and the schema in `secure-cloud-setup.sql` is applied to the same project. Create or choose a dedicated Supabase project for Campus Compass, then add its Project URL and publishable/anon key to `config.js`. Do not reuse a database belonging to another application. Use only the publishable/anon key; never use a `service_role` key in browser code.

### One-time Supabase setup

The secure database schema is included as `secure-cloud-setup.sql`. You previously asked not to run scripts or terminal commands, so **you do not need to run this file yourself**. Connect the Supabase integration in ChatGPT and I can apply the schema and configure the dedicated project for Campus Compass with your approval. Alternatively, a project administrator can apply the included schema through Supabase.

After the backend is configured, the Supabase Project URL and publishable/anon key must be added to `config.js`, and the deployed HTTPS website must be set under **Authentication → URL Configuration** as the Site URL and Redirect URL. Authentication and cross-device sync are not enabled by double-clicking `index.html` from a `file://` path. Test with two different student accounts: each should see only their own profile and roadmap, while both should see a contribution published by either account.

The SQL applies row-level security: students can read and update only their own `cc_profiles` and `cc_private_data` rows; everyone can read `cc_public_posts` and `cc_companies`; only authenticated users can insert public contributions, and the database ties each insert to the authenticated user ID. Public posts are published immediately as requested, so students should avoid uploading phone numbers, email addresses, passwords, private documents or other sensitive personal information.

The included client-side moderation screen is not a secure admin system. A production admin/moderator role, abuse reporting, spam/rate limiting, file-upload storage policies, backups and content takedown workflow still need a trusted server-side/admin configuration. No student can edit or delete another student's public contribution through the current interface.

## Placement data and accuracy

The placement page presents a **curated set of official LPU-reported figures and selected success stories**, not every placement ever made by LPU. LPU's placement-news page is updated over time; use the official links inside the website for the full and latest list. Metrics shown on LPU's overview page and batch-specific PDF may refer to different reporting scopes and are labelled separately.

- Official overview: https://www.lpu.in/placements.php
- Official placement news: https://www.lpu.in/placements-news.php
- Official recruiter/partner page: https://www.lpu.in/companies.php
- Official discipline/company list: https://www.lpu.in/placements2.php
- LPU placement stats PDF: https://www.lpu.in/lpu-assets/download/program-search/annual-report-placements.pdf

Company inclusion does not mean an active vacancy or a confirmed campus drive this semester. City clusters in company profiles are indicative industry hiring hubs, not an exhaustive verified list of that company's Indian offices or facilities. Interview questions are practice prompts unless a dated first-hand student report provides evidence. Do not treat illustrative sample mentor profiles as real people or verified testimonials.

## Suggested production roadmap

1. Real student authentication with verified university email.
2. Private student profiles and synced personal progress using authenticated row-level security.
3. Public interview experiences, guidance and resources with verified contributor identity, moderation and report/correction actions.
4. Admin dashboard with source review, duplicate detection and expiry for stale information.
5. Exact company office/job locations populated from official careers pages and date-checked.
6. Searchable placement archive with batch, discipline, company, role and package filters.
7. Notifications for new verified placement drives and deadlines.

This is a front-end application with Supabase Auth and row-level security integration prepared. It becomes a live multi-user application only after the one-time backend setup and HTTPS deployment described above.


## Version 4 — editorial redesign and interview question collection

- Redesigned the interface with a museum/editorial visual direction: deep forest-green navigation, warm paper surfaces, large serif typography, lime accents, photographic hero, refined cards and smooth micro-interactions. This is an original adaptation of the visual mood and content rhythm of the reference, not a copy of its assets or source code.
- Added a searchable and filterable collection of **150 original practice questions**: 50 Easy, 50 Moderate and 50 Hard. Filter by difficulty, role and company-aligned preparation.
- Question prompts cover software engineering, frontend, backend, data analysis, cybersecurity, cloud/DevOps, QA, business analysis, electronics and mechanical engineering.
- Added a progressive web app manifest, icon and service worker for installability/offline shell caching when served from HTTPS (or localhost). Double-clicking `index.html` still opens the browser preview; service-worker/PWA installation requires hosting on HTTPS.

**Question accuracy:** the 150 items are original role-based practice prompts. Company labels indicate broad preparation relevance only. They are not verified interview questions asked by the named employers. Interview experiences in the feed remain community submissions and must be contributed by actual candidates; demo entries are labelled.

**Cross-device note:** the current student profile and progress tracker remain local browser demo data. Real secure accounts and cross-device personal sync still require Supabase Auth plus protected database policies.


## Visual refresh

This revision uses a restrained cream, forest-green and warm-neutral visual style, a local LPU campus hero image, simpler hover states and subtle page transitions. Interview question prompts now appear inside the existing Interview Experiences feed, using the same difficulty, role, company and search filters; there is no separate question-bank page or standalone question block. The prompts are preparation guidance and are not represented as verified employer interview questions.

## Version 6 — refreshed palette and account privacy

- Replaced the cream/green theme with a cool slate, indigo and soft-coral palette. Added smoother page transitions, card motion, button feedback and reduced-motion accessibility.
- Added Supabase email/password sign-up and sign-in, email verification messaging, password reset and persistent sessions.
- Personal profile and roadmap data use account-owned tables protected by row-level security.
- Student contributions and community-added companies are published to shared public tables and are visible to all visitors. Public posts omit email addresses.
- Added `secure-cloud-setup.sql`; backend activation and HTTPS hosting are still required before authentication and cross-device sync can operate.


## Current backend scope
The connected database includes core tables and access policies for profiles, student records, companies, locations, eligibility, jobs, applications, offers, interview experiences and questions, roadmaps and progress, skills, favorites, notifications, calendar events, and audit logs. The current V6 front end is connected to its compatibility tables for authentication, private roadmap/profile data, and shared company/community content. The full admin console, moderation workflow, and every module in the extended product specification still require phased front-end implementation and testing; this build should not be represented as a completed production placement-management suite.
