#!/usr/bin/env bash
# Meridian Supplies — Host-layer DoS/DDoS hardening (iptables)
# Target: Ubuntu 22.04/24.04 LTS, mgmt segment 10.0.20.0/24
# CIS v8 IG1: 4.4, 4.5, 8.2, 8.5, 13.6
# Run as root. Idempotent — flushes existing filter rules.

set -euo pipefail

IPT="/usr/sbin/iptables"
MGMT_NET="10.0.20.0/24"
OFFICE_NET="10.0.10.0/24"

# ---------- 1. Reset filter table ----------
$IPT -F
$IPT -X
$IPT -Z
$IPT -t mangle -F
$IPT -t mangle -X

# ---------- 2. Default deny posture ----------
$IPT -P INPUT   DROP                                              # CIS 4.4
$IPT -P FORWARD DROP
$IPT -P OUTPUT  ACCEPT

# ---------- 3. Loopback + established/related ----------
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ---------- 4. Drop invalid packets ----------
$IPT -A INPUT -m conntrack --ctstate INVALID -j DROP

# ---------- 5. SYN flood protection (25/s sustained, burst 50) ----------
$IPT -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
$IPT -N SYN_FLOOD
$IPT -A INPUT -p tcp --syn -j SYN_FLOOD
$IPT -A SYN_FLOOD -m limit --limit 25/s --limit-burst 50 -j RETURN
$IPT -A SYN_FLOOD -j LOG --log-prefix "IPT-SYNFLOOD-DROP: " --log-level 4
$IPT -A SYN_FLOOD -j DROP

# ---------- 6. ICMP echo-request rate-limit (10/s burst 20) ----------
$IPT -N ICMP_LIMIT
$IPT -A INPUT -p icmp --icmp-type echo-request -j ICMP_LIMIT
$IPT -A ICMP_LIMIT -m limit --limit 10/s --limit-burst 20 -j ACCEPT
$IPT -A ICMP_LIMIT -j LOG --log-prefix "IPT-ICMP-DROP: " --log-level 4
$IPT -A ICMP_LIMIT -j DROP

# ---------- 7. Stealth-scan drops (NULL, XMAS, FIN, SYN+FIN) ----------
# NULL scan
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "IPT-NULLSCAN-DROP: " --log-level 4
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# XMAS scan
$IPT -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j LOG --log-prefix "IPT-XMASSCAN-DROP: " --log-level 4
$IPT -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP

# FIN scan
$IPT -A INPUT -p tcp --tcp-flags ALL FIN -j LOG --log-prefix "IPT-FINSCAN-DROP: " --log-level 4
$IPT -A INPUT -p tcp --tcp-flags ALL FIN -j DROP

# SYN+FIN illegal combo
$IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOG --log-prefix "IPT-SYNFIN-DROP: " --log-level 4
$IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP

# ---------- 8. Business allowlist ----------
$IPT -A INPUT -p tcp -s $MGMT_NET   --dport 22  -m conntrack --ctstate NEW -j ACCEPT
$IPT -A INPUT -p tcp -s $OFFICE_NET --dport 443 -m conntrack --ctstate NEW -j ACCEPT

# ---------- 9. Catch-all log ----------
$IPT -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPT-CATCHALL-DROP: " --log-level 4

# ---------- 10. Persist ----------
if command -v netfilter-persistent >/dev/null 2>&1; then
    netfilter-persistent save
fi

echo "[+] Meridian iptables hardening applied."
