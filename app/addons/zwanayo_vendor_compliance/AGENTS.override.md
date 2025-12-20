# AGENTS.override.md — zwanayo_vendor_compliance

## Purpose
Vendor compliance workflow: application review, document capture (NUI proof), contract signing, and status transitions.

## Strict rules (override)
- Preserve current vendor status semantics:
  - Approved application -> status "Pending"
  - Vendor can access dashboard to upload NUI + sign contract
  - After both received -> status "Active"
- Do not change existing status codes/labels without explicit approval.
- Any new checks must be additive and default-safe (no mass deactivation).

## Verification checklist
- Create/update a vendor and confirm transitions behave as specified.
- Confirm the vendor dashboard access rules remain correct.
- Confirm no admin/vendor PHP notices in logs for changed pages.

## Output required
- List of hooks/controllers/templates touched + why.
- Manual test steps for: approve -> pending -> upload/sign -> active.
