# Meridian Supplies — Backup & Data Protection Policy

**Policy ID:** MSL-SEC-POL-05
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 11.1, 11.2, 11.3, 11.4, 11.5 · DBIR 2024 ransomware findings

## 1. Backup Strategy — 3-2-1-1-0 Rule
- **3** copies of every Restricted/Confidential dataset.
- **2** different media types (NAS + cloud).
- **1** offsite copy.
- **1** offline / immutable copy (defense against ransomware encrypting backups).
- **0** failed verifications — restore-test monthly.

## 2. What Gets Backed Up

| Asset | Frequency | Retention | Tool | Destination |
|---|---|---|---|---|
| NAS `Restricted/` (financial, contracts) | **Hourly** incremental, daily full | 30 daily, 12 monthly, 7 yearly | **Duplicati** | Local USB HDD + Backblaze B2 (encrypted) |
| NAS `Confidential/` | Daily | 30 daily, 6 monthly | Duplicati | Local NAS + Backblaze B2 |
| Workstation user profiles | Daily | 14 days | Duplicati agent | NAS `Backups/` share |
| AD System State | Daily | 14 days | `wbadmin` scheduled task | NAS Mgmt share |
| pfSense config | On change + weekly | Last 20 versions | pfSense native + git | Mgmt host `/srv/configs/` |
| Suricata / Fail2Ban / iptables configs | On change | Last 20 versions | Git | Mgmt host `/srv/configs/` |
| Owner laptop (FileVault/BitLocker) | Daily | 30 days | Duplicati | Backblaze B2 |

## 3. Encryption & Integrity
- All backups encrypted **client-side** with AES-256 (Duplicati native, passphrase per MSL-SEC-POL-02).
- Backup passphrase stored in Owner's sealed envelope (offline) and Bitwarden vault (online).
- Integrity verified via SHA-256 manifest on every job; nightly cron compares manifest to actual files.

## 4. Immutability (Anti-Ransomware)
- Backblaze B2 bucket configured with **Object Lock (Compliance mode)** — backups cannot be deleted or modified for the retention period, even with root credentials.
- Local USB HDD physically disconnected after each backup ("air-gapped rotation"). Two USB HDDs alternate weekly.

## 5. Access Control
- Backup destinations on Mgmt VLAN (10.0.20.0/24). No write access from Office or OT VLANs.
- Only IT Admin and Owner have credentials to restore from backups.
- Backup service account is **not** a domain admin; minimum-privilege filesystem ACL.

## 6. Restore Testing — Mandatory
- **Monthly:** restore a single random file from each tier to a scratch folder. Verify content. Log result.
- **Quarterly:** full restore of NAS `Restricted/` to a sandbox VM. Time the operation. Compare against RTO target.
- **Annually:** full disaster-recovery drill (see `05_testing/bcp_drill/`).

### 6.1 Recovery Objectives
- **RPO (Recovery Point Objective):** ≤ 1 hour for Restricted; ≤ 24 hours for Confidential.
- **RTO (Recovery Time Objective):** ≤ 4 hours for core ERP and NAS; ≤ 24 hours for workstations.

## 7. Reporting
- Daily backup status email to IT Admin at 06:00.
- Weekly summary to Owner: success/failure count, storage used, last successful restore test.
- Any failed backup investigated within 4 business hours.

## 8. Review Cycle
Quarterly review of backup scope (new shares, new servers); annual review of policy itself.
