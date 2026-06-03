# Meridian Supplies — Staff Security Awareness Training Program

**Program ID:** MSL-TRG-01
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator + HR
**Aligned to:** CIS v8 IG1 Controls 14.1 – 14.9

## 1. Objectives
Equip every Meridian Supplies employee — from warehouse to Owner — with the recognition skills and reporting reflexes to defeat the 2024 DBIR's #1 finding: **68% of breaches involve a non-malicious human element.**

## 2. Audience-Tiered Curriculum

### Tier A — All Staff (28 employees, mandatory)
**Frequency:** Onboarding + quarterly 30-min refresher.

| Module | Topic | Method |
|---|---|---|
| A1 | Recognizing phishing & BEC (with Meridian-specific examples — fake supplier invoices) | 20-min video + quiz |
| A2 | Password hygiene + MFA + Bitwarden walkthrough | Hands-on lab |
| A3 | Safe USB and removable-media handling | 10-min video |
| A4 | Reporting an incident (channels, no-blame) | Role-play |
| A5 | Acceptable Use Policy — data on personal devices | Read + acknowledgement |

### Tier B — Finance & HR (5 employees)
**Frequency:** Tier A + bi-monthly 45-min focused session.

| Module | Topic |
|---|---|
| B1 | Wire-fraud / invoice-fraud red flags (urgency, bank-detail changes, supplier-domain look-alikes) |
| B2 | DPDP Act 2023 — handling personal data of customers and employees |
| B3 | Verifying payment requests out-of-band (phone callback to known number, never the number in the email) |

### Tier C — Remote Sales Reps (4 employees)
**Frequency:** Tier A + onboarding lab.

| Module | Topic |
|---|---|
| C1 | OpenVPN connection, MFA, no-split-tunnel rule |
| C2 | Public Wi-Fi safety (always VPN, no banking on hotel Wi-Fi without VPN) |
| C3 | Device-loss protocol (call IT Admin within 30 minutes) |

### Tier D — IT Administrator (1, self-led)
**Frequency:** Continuous; minimum 40 hours/year structured.

| Module | Topic | Resource |
|---|---|---|
| D1 | TryHackMe / HackTheBox blue-team paths | Self-paced |
| D2 | CIS Controls v8 deep-dive | CIS SecureSuite |
| D3 | Suricata rule-writing | OISF docs + community |
| D4 | DPDP / CERT-In regulatory updates | Quarterly review |

## 3. Phishing Simulation Program

| Cadence | Activity | Tool |
|---|---|---|
| Monthly | 1 phishing simulation across all staff | **GoPhish** (self-hosted on Mgmt VLAN) |
| Quarterly | Review click rates, top offenders, repeat offenders → coaching | GoPhish reports |
| Annual | Live tabletop exercise (see BCP drill) | In-person |

### Click-Rate Targets
- Year 1 baseline → reduce to **< 5% click rate** by end of Year 1.
- Repeat offenders (clicked twice in 90 days) → mandatory 1:1 coaching with IT Admin.

## 4. Onboarding Checklist (HR + IT, first 5 days)
- [ ] Sign Acceptable Use Policy acknowledgement
- [ ] Sign Password Policy attestation
- [ ] Complete Tier A modules A1–A5
- [ ] Enroll MFA on AD, M365, OpenVPN
- [ ] Install Bitwarden + receive vault invite
- [ ] Tier-specific module (B / C if applicable)
- [ ] Issued: laptop with BitLocker, ID badge, MFA token

## 5. Annual Reattestation
Every employee re-signs all policies on hire anniversary; HR tracks completion.

## 6. Measurement & KPIs

| KPI | Target | Reporting |
|---|---|---|
| Tier A completion rate | 100% within 30 days of hire | Quarterly to Owner |
| Phishing simulation click rate | < 5% by month 12 | Monthly trend chart |
| Incident reports submitted | Trending up (= reporting culture working) | Quarterly |
| Policy reattestation rate | 100% on hire anniversary | Annually |

## 7. Resources & Materials
- Free curated content: **NCSC UK Top Tips for Staff**, **CISA Cyber Essentials**, **CERT-In awareness videos**.
- Tools: GoPhish (FOSS), Bitwarden (FOSS), OpenVAS reports as real-world examples.
- Localization: training delivered in **English + Kannada** for warehouse staff.

## 8. Review Cycle
Curriculum refreshed every 6 months to incorporate latest threat patterns from DBIR + IC3 + CERT-In advisories.
