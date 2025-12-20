# AGENTS.md — CS-Cart Add-ons (Local Customizations)

## Scope
This directory contains CS-Cart add-ons only. Work must stay inside add-on folders.

## Non-negotiable rules
- Do not modify CS-Cart core files outside this add-ons directory.
- Do not rename add-on IDs or change folder structures.
- Keep changes backward-compatible with the deployed CS-Cart version.
- Never commit secrets.

## Verification
- Run `php -l` on every changed PHP file.
- Clear CS-Cart cache and smoke test impacted admin/storefront pages.
- If settings/schema change: include explicit upgrade notes and safe defaults.

## Output required
- Files changed + rationale.
- Step-by-step verification (admin + storefront).
- Upgrade/rollback notes when relevant.
