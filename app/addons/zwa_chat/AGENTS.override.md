# AGENTS.override.md — zwa_chat

## Purpose
CS-Cart integration for ZwaChat: expose product/vendor/order data safely, support widget/admin integration, and maintain CS-Cart compatibility.

## Strict rules (override)
- No core edits outside this add-on.
- Any new API endpoints must be:
  - authenticated/authorized (admin key / session / token as appropriate),
  - rate-limited or protected if public-facing,
  - additive (no breaking changes).
- Never expose sensitive customer data unnecessarily (minimize PII).
- Keep integration environment-aware (dev vs prod) without hardcoding secrets.

## Verification checklist
- Confirm add-on installs/enables without errors.
- Confirm expected hooks execute (admin + storefront if applicable).
- Confirm ZwaChat can fetch required data without leaking PII.
- Confirm no PHP notices in logs for changed pages.

## Output required
- Files changed + the integration contract (what ZwaChat calls, what CS-Cart returns).
- Manual test steps: enable add-on → run endpoint checks → widget/admin sanity test.
