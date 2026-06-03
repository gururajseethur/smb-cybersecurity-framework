# Meridian Supplies — Access Control Matrix (RBAC)

**Policy ID:** MSL-SEC-POL-06
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 5.1, 5.4, 6.1, 6.2, 6.6, 6.7, 6.8

## 1. Role Definitions

| Role | Headcount | Description |
|---|---|---|
| Owner / CEO | 1 | Full business authority; segregated from IT admin role |
| IT Administrator | 1 | Sole administrative authority on infra; uses split `adm-` account |
| Finance / Accounts | 3 | Tally ERP, banking, payroll |
| HR | 2 | HRMS, employee records |
| Sales (in-office) | 4 | CRM, customer DB |
| Sales (remote) | 4 | CRM via OpenVPN, restricted hours |
| Office Staff | 8 | General productivity |
| Warehouse | 6 | Barcode terminals, WMS |

## 2. Resource Access Matrix

Legend: **F** Full · **W** Write · **R** Read · **—** No access

| Resource → \ Role ↓ | NAS Restricted | NAS Confidential | NAS Internal | Tally ERP | CRM | M365 Admin | pfSense | OpenVAS | NAS Admin | AD Admin |
|---|---|---|---|---|---|---|---|---|---|---|
| Owner | F | F | F | F | R | F | — | — | — | — |
| IT Admin (`adm-` account) | — | R | R | — | — | F | F | F | F | F |
| IT Admin (daily account) | — | R | R | — | — | R | — | — | — | — |
| Finance | F | R | R | F | R | — | — | — | — | — |
| HR | R (HR subset only) | R (HR subset) | R | — | — | — | — | — | — | — |
| Sales (in-office) | — | R (own region) | R | — | W | — | — | — | — | — |
| Sales (remote) | — | R (own region, via VPN) | R | — | W | — | — | — | — | — |
| Office Staff | — | — | R | — | — | — | — | — | — | — |
| Warehouse | — | — | — | — | — | — | — | — | — | — |

## 3. Network Access by VLAN

| Role | VMnet10 Office | VMnet20 Mgmt | VMnet30 Warehouse/OT | VMnet40 Guest | Remote (OpenVPN) |
|---|---|---|---|---|---|
| Owner | ✓ | — | — | ✓ | ✓ |
| IT Admin | ✓ | ✓ (jump host) | ✓ (jump host, scan only) | ✓ | ✓ |
| Finance / HR / Sales | ✓ | — | — | ✓ | ✓ (sales only) |
| Office Staff | ✓ | — | — | ✓ | — |
| Warehouse | — | — | ✓ | — | — |

## 4. Privileged Access Principles
- **Two-account rule** for IT Admin: `gururaj` for daily work; `adm-gururaj` for privileged tasks. Privileged account is **never** used for email, browsing, or document editing.
- **Just-in-Time elevation** where possible (e.g., temporary domain admin via Bitwarden-stored break-glass account for the Owner — sealed envelope backup).
- **No standing Domain Admin** memberships beyond `adm-gururaj` and `breakglass-owner`.
- **MFA enforced** on all admin logins (per MSL-SEC-POL-01).

## 5. Quarterly Access Review
- IT Admin pulls AD group membership and NAS ACLs to a spreadsheet.
- Owner reviews and signs off.
- Discrepancies remediated within 5 business days.
- Last review date logged in `06_policies/access_review_log.md`.

## 6. Onboarding / Offboarding Checklist Reference
See MSL-SEC-POL-04 §7.
