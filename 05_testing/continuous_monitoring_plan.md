# Meridian Supplies — Continuous Monitoring & SOC Operations Plan

**Document ID:** MSL-SEC-OPS-01
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 8.1, 8.2, 8.4, 8.5, 8.9, 8.11, 13.3, 13.6

## 1. Purpose
Define the daily, weekly, monthly, and quarterly cadence by which Meridian Supplies actively monitors its security posture — moving from "set and forget" to a sustained operating model.

## 2. Log Aggregation Architecture

| Source | Log Type | Forwarded To | Retention |
|---|---|---|---|
| pfSense | Firewall block/pass, Suricata `eve.json` | rsyslog → **Wazuh / Graylog** on 10.0.20.40 | 90 days hot, 1 year cold |
| Ubuntu Mgmt hosts | `journalctl`, `/var/log/auth.log`, fail2ban.log | rsyslog → Wazuh | 90 days |
| Windows endpoints + Server | Defender + Windows Event Logs (via Wazuh agent) | Wazuh | 90 days |
| OpenVAS | Scan reports XML/PDF | NAS Mgmt share + Obsidian vault | 2 years |
| ClamAV | Detection logs | rsyslog → Wazuh | 90 days |
| OpenVPN | Connection + auth logs | rsyslog → Wazuh | 90 days |

Time synchronization across all hosts via NTP (pool.ntp.org via pfSense as internal stratum-2) — mandatory for forensic timeline (CIS 8.4).

## 3. Monitoring Cadence

### 3.1 Daily (≤ 15 min, IT Admin)
- Check Wazuh dashboard: any High/Critical alert overnight?
- `fail2ban-client status` on all hosts — unusual ban spikes?
- `tail /var/log/suricata/fast.log` — any new SIDs?
- Backup status email (06:00) — green?
- Defender / ClamAV — any quarantines?

### 3.2 Weekly (≤ 1 hour, IT Admin, Friday)
- Review top-25 Suricata SIDs by alert count; tune noisy ones.
- pfSense firewall log review — top blocked sources, any internal hosts hitting block rules unexpectedly?
- Patch status: WSUS report + Linux `unattended-upgrades` summary.
- Bitwarden vault — any orphaned credentials from offboarded staff?
- Weekly summary email to Owner (1 paragraph + 3 metrics).

### 3.3 Monthly (≤ 4 hours, IT Admin, first Saturday)
- Run authenticated OpenVAS scan across all subnets.
- Cross-reference findings against CISA KEV → ticket P0/P1.
- Restore-test a random file from each backup tier (per MSL-SEC-POL-05).
- Phishing simulation results review (GoPhish).
- Access review spot-check (5 random AD accounts).

### 3.4 Quarterly (≤ 1 full day, IT Admin + Owner)
- Full vulnerability scan report → Owner briefing.
- Full restore test of NAS `Restricted/` to sandbox VM.
- Access matrix review — quarterly attestation per MSL-SEC-POL-06.
- Suricata rule update audit + ET ruleset version bump.
- Quarterly security KPI report (see §5).

### 3.5 Annual
- DR tabletop drill (`05_testing/bcp_drill/`).
- Third-party penetration test (consider).
- Policy refresh cycle for all MSL-SEC-POL-*.
- Cyber-insurance renewal review.

## 4. Tooling — Wireshark for Ad-Hoc Network Analysis

**Wireshark** (per the brief's recommended tool list) is deployed on the IT Admin's jump host (10.0.20.10) for incident-driven packet analysis. It is **not** a continuous capture — used reactively.

### 4.1 Common Investigation Recipes

```bash
# 1. Confirm a suspicious outbound C2 from a workstation
sudo tcpdump -i ens33 -w /tmp/case-001.pcap host 10.0.10.47 and not port 443
# Then open /tmp/case-001.pcap in Wireshark

# 2. Inspect a Suricata-flagged session — pull flow_id from eve.json,
#    extract corresponding PCAP from Suricata pcap-log
ls /var/log/suricata/pcap/

# 3. Live capture filter examples (Wireshark display filter):
#    tcp.flags.syn == 1 and tcp.flags.ack == 0      → SYN-only (scan / flood)
#    ip.addr == 10.0.10.47 and dns                  → DNS exfil patterns
#    http.request.method == "POST" and http contains "password"  → cleartext creds
#    tls.handshake.type == 1                        → all TLS Client Hellos (find SNI)

# 4. Verify Fail2Ban is actually dropping packets (not just logging)
sudo tcpdump -i ens33 -nn 'src host 10.0.20.99 and dst port 22'
# After ban, this filter should show ZERO packets reaching the host
```

### 4.2 PCAP Storage & Privacy
- Ad-hoc captures stored under `01_evidence/logs/<INC-ID>/`, encrypted at rest.
- Captures containing PII deleted after incident closure unless legal hold applies.
- IT Admin only — no broad packet capture of employee traffic outside of an active incident (privacy + DPDP).

## 5. Security KPIs (Quarterly Owner Briefing)

| KPI | Target | Source |
|---|---|---|
| Mean Time to Detect (MTTD) | ≤ 15 min for P0 | Wazuh alert → ticket timestamp |
| Mean Time to Contain (MTTC) | ≤ 60 min for P0 | Ticket containment timestamp |
| Mean Time to Recover (MTTR) | ≤ 4 hours for P0 | Ticket close timestamp |
| Open Critical Vulns > 72h | 0 | OpenVAS + KEV cross-ref |
| Patch SLA compliance | ≥ 95% | WSUS + apt logs |
| Backup success rate | ≥ 99% | Duplicati daily report |
| Last successful restore test | ≤ 30 days ago | MSL-SEC-POL-05 log |
| Phishing click rate | ≤ 5% (declining) | GoPhish |
| Tier A training completion | 100% within 30d of hire | HR record |
| Policy reattestation rate | 100% on hire anniversary | HR record |

## 6. Escalation Tree

```
P0/P1 Incident
   │
   ▼
IT Admin (primary) ──[ackd ≤ 15 min]──► triage
   │
   ├─[no answer]→ Owner via WhatsApp + phone
   │
   └─[scope grows]→ Cyber-insurance carrier hotline + external IR retainer
                  + CERT-In notification (≤ 6h, mandatory)
                  + DPDP Board (if personal data breach)
```

## 7. Review Cycle
This plan reviewed quarterly; cadence adjusted based on lessons-learned from incidents.
