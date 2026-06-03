# Meridian Supplies — Password & Authentication Policy

**Policy ID:** MSL-SEC-POL-01
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 5.2, 5.3, 5.4, 6.3, 6.5 · NIST SP 800-63B

## 1. Purpose
Define the minimum standard for credential strength, lifecycle, and storage across all Meridian Supplies user, administrative, and service accounts.

## 2. Scope
All 28 employees, contractors, and any account on AD, NAS, pfSense, OpenVPN, M365, Tally ERP, banking portals, and the OpenVAS / SIEM Mgmt segment.

## 3. Policy Statements

### 3.1 Password Composition (per NIST SP 800-63B)
- **Minimum length:** 14 characters for users; **20 characters** for administrators.
- **No mandatory composition rules** (no forced symbols) — length and uniqueness matter more than complexity per current NIST guidance.
- **No periodic rotation** unless evidence of compromise — forced 30/60/90-day rotation is deprecated.
- **Blocklist enforcement:** every new password checked against the HaveIBeenPwned k-anonymity API; common passwords (`Password@123`, `Meridian2025`, etc.) rejected.

### 3.2 Multi-Factor Authentication (MFA) — Mandatory
- **All admin logins** (AD Domain Admins, pfSense webGUI, OpenVPN, NAS admin, M365 Global Admin) require TOTP (Google Authenticator / Aegis).
- **All remote-worker logins** (4 sales reps over OpenVPN) require certificate + TOTP.
- **Banking and Tally ERP** require SMS or TOTP MFA.

### 3.3 Account Lifecycle
- **Provisioning:** Named accounts only. No shared accounts. New-user ticket → AD account → MFA enrollment within 1 business day.
- **Privilege separation:** Domain admins maintain a separate `adm-<name>` account distinct from their daily-driver account.
- **Deprovisioning:** AD account disabled within **2 hours** of HR notification of resignation/termination; full deletion after 30 days.

### 3.4 Password Storage
- Approved password manager: **Bitwarden (self-hosted on Mgmt VLAN)** or **KeePassXC** with cloud-synced KDBX file.
- Plaintext storage in spreadsheets, sticky notes, browser-saved passwords on shared machines, or chat apps is **prohibited**.

### 3.5 Service & Application Accounts
- Service accounts use **40-character random secrets**, stored in Bitwarden, rotated annually or on personnel change.
- No interactive login for service accounts.

## 4. Enforcement
- Annual policy attestation by all employees (sign-off in HR file).
- Quarterly audit by IT Admin: random sample of 5 accounts checked against this policy.
- Non-compliance: first instance → coaching; second → written warning; admin-level breach → immediate account suspension.

## 5. Exceptions
Exceptions require written CISO/Owner approval, time-bound (max 90 days), and compensating control documented.

## 6. Review Cycle
Annual review every 1 June.
