# 🛡️ SMB Cybersecurity Framework — Meridian Supplies

> A cost-effective, defense-in-depth cybersecurity framework for small businesses, built entirely on **free and open-source tools** and aligned to **CIS Controls v8 (IG1)** — validated with live lab evidence.

**Author:** Gururaj Seethuru ([gururajseethur.in](https://gururajseethur.in)) · CEH
**Context:** Cybersecurity internship capstone — "Cybersecurity Framework for Small Businesses"
**Standards:** CIS Critical Security Controls v8 (Implementation Group 1) · Verizon 2024 DBIR · NIST SP 800-63B · CISA KEV · CERT-In Directive (2022) · DPDP Act 2023

---

## 📌 Overview

This project takes a representative 28-person SMB ("Meridian Supplies") from a high-risk posture — flat network, internet-exposed RDP, shared credentials, manual backups — to a **segmented, monitored, recoverable** security architecture. Every recommendation maps to a specific CIS v8 IG1 safeguard, and the core controls are **demonstrated working in a real Ubuntu VM**, not just described.

## 🧪 Live Lab Evidence

The open-source stack was deployed on an Ubuntu 26.04 VM and validated with captured evidence (see [`01_evidence/`](01_evidence/)):

| Control | Tool | Result |
|---|---|---|
| Network DoS mitigation | iptables / nftables | 1935/2000 SYN-flood packets dropped (96.75%); 342 ICMP-flood packets metered |
| Brute-force defense | Fail2Ban | Attacker IP detected & banned via iptables REJECT |
| Intrusion detection | Suricata 8.0 | 50,400 ET Open signatures; 44 named alerts (lateral movement, exposed DB) |
| Endpoint anti-malware | ClamAV 1.4.4 | EICAR detected; 3.6M signatures |
| Network forensics | Wireshark / tshark | 4,349 packets captured + protocol/conversation analysis |
| Vulnerability assessment | nmap + Lynis | Hardening index 61/100 across 265 tests |

![Network Architecture](02_diagrams/network_architecture_diagram.png)

## 📂 Repository Structure

```
.
├── 01_evidence/          # Live lab captures (screenshots, logs, scan results)
├── 02_diagrams/          # Network architecture diagram
├── 03_report/            # Master framework document (PDF + Markdown)
├── 04_tools_config/      # Production-ready configs: iptables, nftables, Fail2Ban
├── 05_testing/           # Continuous-monitoring plan + BCP recovery drill
├── 06_policies/          # 6 security policies (password, encryption, IR, AUP, backup, access)
└── 07_training/          # Staff security-awareness program
```

## 📋 Brief Requirement → File Map

| Requirement | Location |
|---|---|
| Threat analysis (5 threats + attack patterns) | `03_report/` §1 |
| Packet filtering / DoS rate-limiting | `03_report/` §4 + `04_tools_config/` |
| Framework selection (NIST vs CIS) | `03_report/` §2 |
| Risk Assessment (5×5 matrix) | `03_report/` §5.2 |
| Security Policies & staff training | `06_policies/` + `07_training/` |
| Network Security (firewall, secure Wi-Fi, vuln scans) | `03_report/` §3, §3.3 |
| Endpoint Security (FOSS AV/EDR) | `03_report/` §3.2 |
| Data Protection (encryption, access, backups) | `06_policies/02,05,06` |
| Incident Response + recovery drill | `03_report/` §5.3 + `05_testing/bcp_drill/` |
| Action Plan & Timeline | `03_report/` §5.1 |
| Continuous monitoring | `05_testing/continuous_monitoring_plan.md` |

## 🧰 Open-Source Tool Stack

`pfSense` · `Suricata` · `ClamAV` · `Fail2Ban` · `iptables` / `nftables` · `Wireshark` · `OpenVAS` (prod) / `nmap` + `Lynis` (lab) · `VeraCrypt` · `Duplicati` · `Bitwarden` · `Wazuh`

## ⚙️ Rebuild the PDF

```bash
# Requires pandoc + a LaTeX engine
cd 03_report
pandoc Gururaj_Seethuru_Meridian_Project.md \
       -o Gururaj_Seethuru_Meridian_Project.pdf \
       --pdf-engine=xelatex -V geometry:margin=1in --toc
```

## ⚠️ Disclaimer

"Meridian Supplies" is a fictional company created for this academic project. The configurations and evidence are real and were generated in an isolated lab VM. Tool configs use placeholder addresses (`*.local`) and contain no real credentials. Use the configs as a reference baseline — review and adapt before deploying to any production environment.

## 📄 License

Released under the [MIT License](LICENSE).
