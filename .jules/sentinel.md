## 2026-10-17 - Invalid nftables TCP Flags Bitmask Syntax
**Vulnerability:** The nftables DoS hardening configuration in `04_tools_config/nftables.conf` and `03_report/Gururaj_Seethuru_Meridian_Project.md` used `tcp flags syn,fin == syn,fin`, causing an `unexpected ==` syntax error on load and preventing the firewall ruleset from being applied.
**Learning:** `nftables` expects bitwise operation syntax `tcp flags & (syn|fin) == syn|fin` or flag matching keywords rather than mixing flag lists with comparison operators like `==`.
**Prevention:** Always validate `nftables` configuration syntax before deployment using `nft -c -f <config>` or equivalent testing tools.
