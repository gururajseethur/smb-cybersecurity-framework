# Meridian Supplies — Acceptable Use & Data Handling Policy

**Policy ID:** MSL-SEC-POL-04
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 3.1, 3.3, 14.1 · DPDP Act 2023

## 1. Scope
All Meridian Supplies–issued or –managed devices (workstations, laptops, mobile phones, USB media) and all use of corporate accounts, network, and data.

## 2. Permitted Use
- Business activities supporting Meridian Supplies operations.
- Reasonable, occasional personal use that does not consume business bandwidth, expose risk, or violate this policy.

## 3. Prohibited Use
- Storing customer PII, financial data, or contracts on **personal devices, personal email, or personal cloud accounts** (Gmail, personal OneDrive, WhatsApp, Telegram).
- Connecting unknown USB devices to corporate workstations.
- Disabling Defender, ClamAV, Fail2Ban, or any security tool without IT Admin approval.
- Sharing user accounts. Each named user uses their own credentials.
- Visiting known-risky sites (torrents, pirated software, cracking sites) on corporate network.
- Installing unapproved software. Approved software list is published on the intranet.
- Forwarding suspicious emails to personal accounts to "deal with later" — report them per MSL-SEC-POL-03 instead.
- Bypassing the OpenVPN tunnel for remote work.

## 4. Data Handling Quick Rules

| Data Type | Storage | Transmission | Retention |
|---|---|---|---|
| **Customer PII** | NAS `Restricted/` share only; VeraCrypt for offline copies | Encrypted email or M365 secure share only | Per DPDP minimisation; max 5 years after last transaction |
| **Financial / payment** | Mgmt VLAN file server, AD-restricted | TLS-encrypted ERP / banking portal | 8 years (statutory) |
| **Internal docs** | NAS `Internal/` | Corporate email OK | 3 years |
| **Public marketing** | Any approved location | Any channel | No limit |

## 5. BYOD (Bring Your Own Device)
- Personal phones may access corporate email **only** through M365 mobile apps with MDM enrolment (PIN, remote wipe, no copy-paste to non-corporate apps).
- Personal laptops are **not permitted** to connect to internal VLANs. Guest Wi-Fi (VMnet40) is available with internet-only access.

## 6. Removable Media
- USB drives must be issued and inventoried by IT Admin.
- Auto-run is disabled on all workstations.
- USB ports on Finance and Owner workstations are set to **read-only** by GPO.
- All connected USB media is automatically ClamAV-scanned on insert.

## 7. Departing Employee Checklist (HR + IT)
- AD account disabled within 2 hours of last working day notification.
- VPN certificate revoked.
- Mailbox set to forward to manager for 30 days, then archived.
- Bitwarden corporate vault access removed.
- Device returned and reimaged.
- Exit interview includes data-return attestation (signed).

## 8. Monitoring & Privacy
Meridian Supplies monitors corporate network traffic, email metadata, and endpoint security telemetry for security and compliance purposes. Employees should have **no expectation of privacy** when using corporate systems. Personal content on personal devices outside the BYOD scope is not monitored.

## 9. Acknowledgement
All employees sign acknowledgement on hire and re-attest annually. Signed copies kept in HR file.
