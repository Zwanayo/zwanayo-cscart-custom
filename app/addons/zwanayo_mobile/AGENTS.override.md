# AGENTS.override.md — zwanayo_mobile

## Purpose
Mobile API add-on used by the Zwanayo React Native app. Stability and backward compatibility are critical.

## Strict rules (override)
- Do not break existing endpoints or response shapes.
- Only additive changes to payloads unless explicit approval is given.
- Version any breaking change (v2 route or explicit version field), never silent changes.
- Error responses must be consistent and machine-readable.

## Verification checklist
- Smoke test key endpoints used by the app (auth, categories, products, cart, orders).
- Confirm API base URL behavior remains unchanged.
- If you add fields: confirm existing clients still parse successfully.

## Output required
- Endpoint-by-endpoint summary of changes (what changed, what stayed stable).
- Example request/response for any modified endpoint.
