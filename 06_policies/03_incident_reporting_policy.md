# Meridian Supplies — Incident Reporting Policy & Procedure

**Policy ID:** MSL-SEC-POL-03
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 17.1, 17.2, 17.3, 17.4 · CERT-In Directive (Apr 2022) · DPDP Act 2023

## 1. Purpose
Establish the channel, timeline, and content requirement for reporting suspected or confirmed security incidents at Meridian Supplies.

## 2. What to Report — Examples
- Suspected phishing email (clicked or not).
- Lost / stolen laptop, phone, USB drive, or printed customer data.
- Suspicious workstation behavior (unknown popups, files renamed to `.locked`, ransom notes, browser hijack).
- Unauthorized access attempt (someone trying to use your account, tailgating, unknown person in office).
- Confirmed malware detection by Defender / ClamAV.
- Accidental disclosure (email to wrong recipient with sensitive attachment).
- Any DPDP-relevant personal data breach (customer PII exposed).

**Golden rule: When in doubt, report. False alarms are free; missed breaches are not.**

## 3. How to Report

### 3.1 Reporting Channels (in priority order)
1. **Email** → `security@meridian.local` (monitored by IT Admin, 09:00–18:00)
2. **Phone / WhatsApp** → IT Admin direct line (24×7): **[+91-XXXXX-XXXXX]**
3. **In-person** → IT Admin office (Mgmt segment workstation)
4. **Out-of-band fallback** (if corporate email/phone may be compromised) → Signal group `Meridian-IR`

### 3.2 Required Information in Report
- **Who** — your name, department.
- **When** — date and time you first noticed.
- **Where** — affected machine name (sticker on workstation), location.
- **What** — what you observed, in plain words.
- **Action taken** — did you click, reply, plug in anything, run something? Be honest. No blame.

## 4. Response Timeline (SLA)

| Severity | Examples | IT Admin Acknowledges | Containment Target | Executive Notified |
|---|---|---|---|---|
| **P0 Critical** | Active ransomware, confirmed data breach, financial fraud in progress | ≤ 15 min | ≤ 1 hour | Immediately (Owner + insurance) |
| **P1 High** | Confirmed malware, lost device with Restricted data, account takeover | ≤ 1 hour | ≤ 4 hours | Same day |
| **P2 Medium** | Phishing email (not clicked), failed exploit attempt, lost low-sensitivity device | ≤ 4 hours | Next business day | If trend visible |
| **P3 Low** | Policy violation, spam, suspicious-but-benign behavior | Next business day | Next business day | Monthly summary |

## 5. Investigation & Documentation
- Every incident gets a ticket: `INC-YYYY-MMDD-NNN` in the IR log (Obsidian / shared sheet).
- Evidence (logs, screenshots, suspicious files) preserved in `01_evidence/logs/<INC-ID>/` on Mgmt segment with read-only ACL.
- Chain-of-custody form signed if device is physically seized.

## 6. External Reporting Obligations

| Trigger | Authority | Deadline |
|---|---|---|
| Personal data breach affecting ≥ 1 data principal | **DPDP Board of India** + affected individuals | "As soon as possible" per DPDP Act 2023 |
| Cyber incident (ransomware, BEC, etc.) | **CERT-In** via `incident@cert-in.org.in` | **Within 6 hours** (CERT-In Directive Apr 2022) |
| Financial fraud > ₹50,000 | Local police cyber cell + bank | ≤ 24 hours |
| Cyber-insurance carrier | As per policy | Per policy SLA |

## 7. No-Retaliation Clause
Employees reporting in good faith — including reporting their own mistakes — will not face disciplinary action for the act of reporting. Concealment or delayed reporting **is** a disciplinary matter.

## 8. Drills & Awareness
- Phishing simulation every quarter (see Training Plan §07_training).
- Tabletop drill annually (see `05_testing/bcp_drill/`).
- New-hire briefing on this policy within first 5 days.

## 9. Review Cycle
Annual; after every P0/P1 incident; whenever regulatory landscape changes.
