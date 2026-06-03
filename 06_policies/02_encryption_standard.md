# Meridian Supplies — Data Encryption Standard

**Policy ID:** MSL-SEC-POL-02
**Version:** 1.0 | **Effective:** 03 June 2026 | **Owner:** IT Administrator
**Aligned to:** CIS v8 IG1 Controls 3.6, 3.10, 3.11 · DPDP Act 2023 §8(5)

## 1. Purpose
Specify minimum cryptographic algorithms, key strengths, and protocols for data at rest, data in transit, and key management at Meridian Supplies.

## 2. Approved Algorithms

| Use Case | Approved Algorithm | Minimum Key Size | Notes |
|---|---|---|---|
| Symmetric encryption (files, disks) | AES-GCM / AES-XTS | 256-bit | XTS for full-disk; GCM for files |
| Asymmetric encryption / signing | RSA or ECDSA (P-256, P-384) | RSA 3072-bit / ECC 256-bit | New issuance uses ECC |
| Hashing (general) | SHA-256, SHA-384 | — | SHA-1 / MD5 prohibited |
| Password hashing | Argon2id (preferred) or bcrypt (cost ≥ 12) | — | No PBKDF2 < 600k iterations |
| TLS | TLS 1.2 (legacy) / **TLS 1.3 (required for new)** | — | SSLv3, TLS 1.0/1.1 disabled |
| VPN | OpenVPN with TLS 1.3, AES-256-GCM, SHA-384 HMAC | — | IKEv2 acceptable alternative |
| HDD / SSD encryption | BitLocker (XTS-AES-256) on Windows; **LUKS2 (AES-XTS-256)** on Linux; **FileVault (XTS-AES-256)** on macOS | 256-bit | TPM-backed where available |

## 3. Data Classification & Encryption Requirement

| Class | Examples | At Rest | In Transit |
|---|---|---|---|
| **Restricted** | Customer PII, financial records, salary data, contracts | **Mandatory** — VeraCrypt container or BitLocker volume | Mandatory TLS 1.3 |
| **Confidential** | Internal sales reports, pricing sheets, vendor lists | Mandatory (drive-level OK) | Mandatory TLS |
| **Internal** | Internal memos, calendars, non-sensitive ops data | Drive-level encryption | TLS preferred |
| **Public** | Marketing material, website copy | Not required | Not required |

## 4. Implementation Tooling (FOSS-First)

| Layer | Tool | Configuration |
|---|---|---|
| Endpoint full-disk (Windows) | **BitLocker** | XTS-AES-256, TPM 2.0 + PIN, recovery key escrowed in AD |
| Endpoint full-disk (Linux mgmt hosts) | **LUKS2 (cryptsetup)** | `aes-xts-plain64`, 512-bit key, argon2id keyslot |
| File containers | **VeraCrypt** | AES-256, SHA-512, PIM ≥ 485 |
| Backups (Duplicati) | **AES-256** native encryption | Passphrase stored in Bitwarden, separate from backup target |
| Email | **TLS 1.3 enforced** on M365 outbound; S/MIME for Finance↔Owner |
| Web (internal apps) | **Let's Encrypt + ACME** on internal CA-signed certs; HSTS 1y, no mixed content |

## 5. Key Management
- Backup encryption keys held by **Owner (CEO) and IT Administrator** in sealed envelopes in fireproof safe; digital copy in Bitwarden vault.
- Key rotation: VPN CA every 2 years; per-user VPN cert every 1 year; service account credentials annually or on staff change.
- Key destruction: cryptographic erasure (overwrite key, then destroy media) for decommissioned drives containing Restricted data.

## 6. Prohibited
- Self-signed certificates on production-facing services (use Let's Encrypt or internal CA).
- Hard-coded encryption keys in source/config files committed to Git.
- Use of deprecated algorithms (RC4, DES, 3DES, MD5, SHA-1, SSLv2/3, TLS 1.0/1.1).

## 7. Review Cycle
Annual review; immediate review if NIST or CIS deprecates an algorithm in use.
