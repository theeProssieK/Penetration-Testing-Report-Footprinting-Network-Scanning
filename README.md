# Penetration-Testing-Report-Footprinting-Network-Scanning
<div align="center">

# 🛡️ Penetration Testing Report

### Footprinting & Network Scanning Phases

![Status](https://img.shields.io/badge/Status-Completed-success)
![Platform](https://img.shields.io/badge/Platform-Kali%20Linux-557C94?logo=kalilinux&logoColor=white)
![Tool](https://img.shields.io/badge/Tool-Zenmap%20%2F%20Nmap-blue)
![Purpose](https://img.shields.io/badge/Purpose-Educational-orange)

**WEEK 2 LAB | CYBERSECURITY | NETWORKWALKS**

</div>

---

## 📑 Table of Contents

1. [Report Details](#-report-details)
2. [Liability Disclaimer](#-1-liability-disclaimer)
3. [Introduction](#-2-introduction)
4. [Tools Used](#-3-tools-used)
5. [Activities Performed](#-4-activities-performed)
   - [4.1 Footprinting & Reconnaissance](#41-footprinting--reconnaissance)
   - [4.2 Network Scanning with Zenmap](#42-network-scanning-with-zenmap)
6. [Risk Analysis / Impact](#-5-risk-analysis--impact)
7. [Recommendations](#-6-recommendations)
8. [Conclusion](#-7-conclusion)
9. [Evidences Collected](#-8-evidences-collected)

---

## 📋 Report Details

| Field | Detail |
| ----- | ------ |
| **Pentester Name** | PROSSY KAWUMA NANTUMBWE |
| **Program / Batch** | NW-084 |
| **Date** | November,2026|
| **Modules Completed** | Footprinting with multiple Kali tools<br>Network scanning with Zenmap |
| **Client / Target** | 1. networkwalks.com (written permission secured)<br>2. My own local LAN |
| **Permission Secured?** | ✅ Yes |
| **Phases Covered** | **Phase 1:** Reconnaissance & Footprinting<br>**Phase 2:** Scanning & Network Discovery |

---

## ⚠️ 1. Liability Disclaimer

> I performed these activities only on systems and devices where I had written permission, or that I own myself. All material in this repository is for **education and research purposes only**. Do not use anything here to break the law. The instructor, the author and Networkwalks are not responsible for how this knowledge is used. Every action you take is your own responsibility. Unauthorised access is a crime in most countries, even when nothing is damaged.

---

## 📖 2. Introduction

This report covers two activities from my Cybersecurity internship program at Networkwalks:

- **Footprinting** the `networkwalks.com` domain using six Kali Linux tools: `whois`, `whatweb`, `nslookup`, `curl`, `wafw00f` and `dnsrecon`.
- **Network scanning** of my own local network using Zenmap (the Nmap GUI).

Together they show how an attacker moves from gathering public information about a target to mapping live hosts on a network.

Footprinting was done from **Kali Linux** (running in VirtualBox) and all commands were passive or low-impact: they read public records and standard web responses. Scanning was done with **Zenmap** on `YOUR OS`. Every step below includes the command, the result I observed, and a screenshot as evidence.

---

## 🧰 3. Tools Used

| Tool | Purpose |
| ---- | ------- |
| **Kali Linux** | Operating system used for reconnaissance |
| **whois** | Find domain registration details (registrar, dates, name servers) |
| **whatweb** | Fingerprint web technologies (server, CMS, plugins, IP) |
| **nslookup** | Resolve the domain name to its IP address using DNS |
| **curl -I** | Read the HTTP response headers of the website |
| **wafw00f** | Detect whether a Web Application Firewall (WAF) protects the site |
| **dnsrecon** | Enumerate DNS records (SOA, NS, MX, A, SRV) |
| **Zenmap (Nmap GUI)** | Scan the local subnet for live hosts, IPs and MAC addresses |
| **ipconfig** | Identify local IP address and subnet |

---

## 🔍 4. Activities Performed

### 4.1 Footprinting & Reconnaissance

Target: `networkwalks.com` (authorised).

#### 1️⃣ WHOIS: domain registration

```bash
whois networkwalks.com
```

**Result:**

| Field | Value |
| ----- | ----- |
| Domain name | NETWORKWALKS.COM |
| Registrar | GoDaddy.com, LLC |
| Creation date | 2019-11-06 |
| Registry expiry date | 2027-11-06 |
| Last updated | 2025-11-12 |
| Name servers | NS6135.HOSTGATOR.COM, NS6136.HOSTGATOR.COM |
| DNSSEC | unsigned |
| Domain status | clientDeleteProhibited, clientRenewProhibited, clientTransferProhibited, clientUpdateProhibited |

**Why it matters:** WHOIS reveals who registered the domain, when it was created and which name servers host it. The `client...Prohibited` statuses are registrar locks that protect the domain from accidental or unauthorised changes, which is good practice. The name servers show the site is hosted with HostGator.

#### 2️⃣ WhatWeb: web technology fingerprinting

```bash
whatweb networkwalks.com
```

**Result:**

- HTTP (`http://`) returns **301 Moved Permanently** and redirects to HTTPS.
- HTTPS returns **200 OK**.
- Web server: **Apache**
- CMS: **WordPress** (version shown in the scan: `7.1.4`)
- Plugin detected: **WordPress Download Manager** (`3.3.76`)
- JavaScript library: **jQuery 3.7.1**
- Other: HTML5, Google Tag Manager, Open Graph, HttpOnly cookie `__wpdm_client`
- Contact email exposed in the page: `info@networkwalks.com`
- Server IP: `192.232.216.135`
- Page title: **Networkwalks Academy**

**Why it matters:** WhatWeb shows the site runs on WordPress with at least one plugin. Knowing the CMS, plugin and version tells an attacker exactly which public advisories to look up.

#### 3️⃣ Nslookup: DNS resolution

```bash
nslookup networkwalks.com
```

**Result:** `networkwalks.com` resolves to **192.232.216.135** (non-authoritative answer, resolved through my local router's DNS at `192.168.1.1`).

**Why it matters:** This identifies the public IP address of the web server, which is the starting point for any further network-level testing.

#### 4️⃣ Curl: HTTP header inspection

```bash
curl -I http://networkwalks.com
```

**Result:**

- `HTTP/1.1 301 Moved Permanently`, `Location: https://networkwalks.com/` (HTTP is redirected to HTTPS)
- `Server: Apache`
- `X-Redirect-By: WordPress - Really Simple Security`
- `X-nginx-cache: WordPress` and `X-Endurance-Cache-Level: 0`
- `Permissions-Policy` and `Referrer-Policy: no-referrer-when-downgrade` headers present
- `Set-Cookie: __wpdm_client=...; HttpOnly`
- `Upgrade: h2,h2c`

**Why it matters:** Response headers show that HTTPS is enforced and some security headers are set (good). They also leak implementation details: the security plugin (Really Simple Security) and the caching layer in use.

#### 5️⃣ Wafw00f: WAF detection

```bash
wafw00f networkwalks.com
```

**Result:** The site `https://networkwalks.com` is behind the **ModSecurity (SpiderLabs) WAF**. Number of requests: 2.

**Why it matters:** A WAF filters malicious web requests. Knowing it is ModSecurity tells a tester which kind of filtering to expect, and confirms the site has a protective layer in front of it.

#### 6️⃣ DNSRecon: DNS enumeration

```bash
dnsrecon -d networkwalks.com
```

**Result:**

| Record | Value |
| ------ | ----- |
| SOA | ns6135.hostgator.com (50.87.144.87) |
| NS | ns6136.hostgator.com (192.232.216.131) |
| NS | ns6135.hostgator.com (50.87.144.87) |
| MX | mail.networkwalks.com (192.232.216.135) |
| A | networkwalks.com (192.232.216.135) |
| SRV | `_autodiscover._tcp` pointing to `cpanelemaildiscovery.cpanel.net` (443) |
| DNSSEC | No answer for DNSSEC query (not enabled) |
| BIND version | name server `192.232.216.131` reported a version string (`9.16.23-RH`) |

**Why it matters:** DNSRecon maps the domain's DNS infrastructure: the name servers, the mail server and the autodiscover records for cPanel email. The mail server sits on the same IP as the website, and one name server disclosed its software version.

---

### 4.2 Network Scanning with Zenmap

The goal was to identify my local IP and subnet, discover live hosts, record their IP and MAC addresses, and generate a network topology.

**Step 1: Find my IP address and subnet**

```cmd
ipconfig
```

**Result:** IPv4 address 192.168.x.x, subnet mask 10.x.x.x, so the subnet is . 192.168.*.*/*

**Step 2: Run a Ping Scan in Zenmap**

- **Target:**192.168.x.x/x** 
- **Profile:** Ping scan
- **Equivalent command:**

```bash
nmap -sn 192.168.x.x/x
```

**Live hosts discovered:**

| # | IP Address | Device |
| - | ---------- | ----- |
| 1 | 192.168.x.x |  router / gateway |
| 2 | 192.168.x.x | my PC |
| 3 | 192.168.x.x | DEVICE |

**Step 3: Generate the topology**

Opened the **Topology** tab in Zenmap, enabled the legend, and saved the map as a PDF.

---

## ⚡ 5. Risk Analysis / Impact

| # | Risk / Finding | Evidence / Observation | Potential Impact | Risk Level |
| - | -------------- | ---------------------- | ---------------- | ---------- |
| 1 | CMS, plugin and version information exposed | WhatWeb shows WordPress and WordPress Download Manager with version numbers | Attackers can match versions against public advisories | 🟡 Medium |
| 2 | DNS server software version disclosed | DNSRecon returned a BIND version string from `192.232.216.131` | Helps attackers target known issues in that software | 🟡 Medium |
| 3 | DNSSEC not enabled | WHOIS shows `DNSSEC: unsigned`; DNSRecon got no DNSSEC answer | Weaker protection against DNS spoofing | 🟢 Low |
| 4 | Technical details leaked in HTTP headers | `X-Redirect-By`, `X-nginx-cache`, `X-Endurance-Cache-Level` | Reveals plugins and caching layers in use | 🟢 Low |
| 5 | Public email address exposed | `info@networkwalks.com` found in page content | Possible target for phishing or spam | 🟢 Low |
| 6 | Web server and mail server share one IP | A and MX records both point to `192.232.216.135` | One host failure or compromise affects both services | 🟢 Low |
| 7 | Multiple live hosts visible on LAN | `Zenmap result` | Unknown or unauthorised devices may be present | 🟡 Medium |

**Good practices observed:** HTTP redirects to HTTPS, a ModSecurity WAF is in front of the site, registrar locks are enabled on the domain, and `Permissions-Policy` and `Referrer-Policy` headers are set.

**Risk key:** 🔴 Critical · 🟡 Medium · 🟢 Low

> **Note:** These are observations, not confirmed vulnerabilities. This lab involved only information gathering and host discovery. No exploitation was performed. A software version, IP address or DNS record does not by itself mean a system is vulnerable. Further authorised testing would be needed to confirm any real vulnerability.

---

## ✅ 6. Recommendations

1. **Keep WordPress, themes and plugins updated.** Check WordPress Download Manager and Really Simple Security against current security advisories.
2. **Hide software versions.** Remove version numbers from page output and meta tags where possible.
3. **Hide the BIND version.** Ask the DNS host (or configure it) so the name server does not report its version.
4. **Enable DNSSEC** with the registrar and DNS provider to protect against DNS spoofing.
5. **Trim HTTP response headers.** Remove unnecessary headers that reveal plugins and caching layers.
6. **Keep the WAF enabled and tuned.** Review ModSecurity rules and logs regularly.
7. **Protect public contact addresses.** Use a contact form or obfuscation, and enable email filtering against phishing.
8. **Perform regular internal network discovery.** Periodically scan your own network to find active devices, and investigate any unknown host.
9. **Test only with authorisation.** Scan only systems you own or have written permission to test.

---

## 🏁 7. Conclusion

During Week 2 of my Cybersecurity & Ethical Hacking internship, I completed practical activities covering footprinting, reconnaissance and network scanning.

In the footprinting activity, I used six Kali Linux tools to collect information about `networkwalks.com`. WHOIS showed the domain is registered through GoDaddy with registrar locks, WhatWeb showed it runs on WordPress with Apache, Nslookup resolved it to `192.232.216.135`, Curl showed that HTTP redirects to HTTPS, Wafw00f confirmed a ModSecurity WAF, and DNSRecon mapped the DNS and mail records.

In the scanning activity, I used Zenmap to identify my network configuration, discover active hosts, collect IP and MAC addresses and create a network topology.


---

## 🖼️ 8. Evidences Collected

*Screenshots are stored in the [`screenshots/`](./screenshots) folder.*

| Tool | Evidence |
| ---- | -------- |
| WHOIS |![whois](Screenshot%202026-11-11%20005632.png)|
| WhatWeb | ![whatweb](Screenshot%202026-11-11%20010049.png) |
| Nslookup | ![nslookup](Screenshot%202026-11-11%20010244.png) |
| Curl | ![curl](Screenshot%202026-11-11%20010722.png) |
| Wafw00f | ![wafw00f](screenshots/5_wafw00f.png) |
| DNSRecon | ![dnsrecon](screenshots/6_dnsrecon.png) |
| Zenmap scan | ![zenmap scan](screenshots/7_zenmap.png) |
| Zenmap topology | ![zenmap topology](screenshots/8_zenmap_topology.png) |

---

<div align="center">

**— End of Report —**

Made by `PROSSY KAWUMA NANTUMBWE` · Networkwalks Cybersecurity Internship

</div>
