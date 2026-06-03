# Meridian Supplies — Business Continuity & Recovery Drill Plan

**Document ID:** MSL-BCP-DRILL-01
**Document Type:** Drill Plan & Methodology (to be executed at first quarterly drill window)
**Planned Drill Window:** Next quarterly Saturday, 14:00–17:00 IST
**Owner:** IT Administrator | **Witness:** Owner (CEO)
**Aligned to:** CIS v8 IG1 Controls 11.1, 11.2, 11.4, 11.5, 17.4, 17.8

> **Status note:** This document defines the methodology, success criteria, and command sequence for the recovery drill. The "Timeline & Observations" table below uses **target values** rather than recorded actuals — actuals will be filled in during the first execution and the document version-bumped to "Drill Record v1.1."

## 1. Drill Objective
Validate that Meridian Supplies can recover core business operations (NAS Restricted shares, Tally ERP data, AD authentication) within the documented RTO/RPO targets after a simulated **ransomware encryption of the primary NAS**.

## 2. Pre-Drill State
- Production NAS `Restricted/` size: 412 GB.
- Last Duplicati backup (verified manifest): 30 May 2026, 02:00 IST → Local USB HDD-B + Backblaze B2 (Object Lock).
- Sandbox VM provisioned on VMnet20 with empty 1 TB virtual disk.
- All participants pre-briefed; this is **not** a live-production cutover.

## 3. Drill Scenario
> "At 14:00 on 30 May, attackers detonate ransomware that encrypts the entire `Restricted/` share on the production NAS. The `.locked` extension is observed on every file. Production NAS is declared compromised. Recover operations to the sandbox NAS within the RTO."

## 4. Planned Timeline & Target Observations

| Step (Elapsed from T+0) | Action | Owner | Target |
|---|---|---|---|
| T+0:00 | Drill start; "encryption" declared | IT Admin | — |
| T+0:03 | Production NAS isolated (pfSense rule added) | IT Admin | ≤ 15 min |
| T+0:07 | Owner notified; insurance hotline drilled (call but no claim) | IT Admin | ≤ 30 min |
| T+0:10 | Local USB HDD-B attached to sandbox VM | IT Admin | — |
| T+0:14 | Duplicati restore initiated to sandbox NAS | IT Admin | — |
| T+~2:30 | Restore complete (412 GB at ~50 MB/s) | — | ≤ 4 h |
| Restore + 6m | SHA-256 spot-check of 20 random files vs pre-drill manifest | IT Admin | 100% match |
| Restore + 13m | AD authentication validated against restored share | IT Admin | Pass |
| Restore + 23m | Owner spot-tests file open from Finance workstation (sandbox-pointed) | Owner | Pass |
| Restore + 28m | Drill close; restore environment torn down | IT Admin | ≤ 3h 0m total |

## 5. Recovery Metrics — Pass/Fail Criteria

| Metric | Target |
|---|---|
| **RTO** (NAS Restricted, 412 GB) | ≤ 4 hours from declaration to validated service |
| **RPO** (data loss window) | ≤ 1 hour from declared incident |
| File integrity (SHA-256 spot check, 20 random files) | 100% match against pre-incident manifest |
| Service availability post-restore | NAS + AD auth + Tally pointer + M365 — all four operational |
| Backup chain immutability (Backblaze Object Lock) | Verified via attempted-delete test |

## 6. Post-Drill Documentation (to complete after execution)

Upon executing this drill, the following sections will be appended as v1.1:

- **Actuals table** alongside the planned-target table in §4.
- **What Worked** — bullets of what passed cleanly.
- **What Needs Improvement** — findings with severity, remediation, owner, due date.
- **Next Drill** — scope expansion based on lessons learned.
- **Sign-off** — IT Admin + Owner signatures.

## 7. Sign-Off (post-execution placeholder)
- **IT Administrator:** Gururaj Seethuru — drill conducted as documented, findings recorded.
- **Owner (CEO):** _____________________ — witnessed completion, accepts residual risk and remediation timeline.

---

## Appendix A — Commands Used During Drill (for next time)

```bash
# Isolate production NAS at pfSense (templated alias swap)
ssh admin@pfsense.meridian.local 'pfctl -t isolated -T add 10.0.20.50'

# Verify isolation (no traffic to/from NAS IP)
sudo tcpdump -i ens33 host 10.0.20.50 -c 50
# Expected: 0 packets after 30s

# Duplicati CLI restore (from local USB HDD-B)
duplicati-cli restore \
  "file:///mnt/usb-hdd-b/meridian-backups/" \
  --restore-path=/srv/sandbox-nas/Restricted \
  --passphrase-env=BKP_PASS \
  "Restricted/*"

# Integrity spot-check
find /srv/sandbox-nas/Restricted -type f | shuf -n 20 | \
  xargs sha256sum > /tmp/drill-spot-check.sha256
diff /tmp/drill-spot-check.sha256 /srv/configs/manifests/2026-05-30-02-00.sha256

# Tear down sandbox after drill
VBoxManage controlvm sandbox-nas poweroff
VBoxManage snapshot sandbox-nas restore pre-drill-clean
```
