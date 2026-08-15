# bypass-503

<p align="center">
  <img src="https://img.shields.io/badge/version-2.1.3-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/shell-bash-blue?style=for-the-badge&logo=gnubash" />
  <img src="https://img.shields.io/badge/license-MIT-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/techniques-16+-red?style=for-the-badge" />
  <img src="https://img.shields.io/badge/maintained-yes-success?style=for-the-badge" />
</p>

<p align="center">
  <b>A simple script to bypass 503 Service Unavailable errors</b><br/>
  <i>Inspired by <a href="https://github.com/iamj0ker/bypass-403">bypass-403</a> — extended for 5xx range</i>
</p>

---

```
  ____   ___ ___        ____
 | ___| / _ \__ \      |  _ \
 |___ \| | | | ) |_____| |_) |_   _ _ __   __ _ ___ ___
  ___) | | | |/ /______|  _ <| | | | '_ \ / _` / __/ __|
 |____/ \___//_/       |_| \_\ |_| |_| .__/ \__,_\___\___|
                                      |_|
```

---

## 📌 What is this?

A Bash script that attempts to bypass **HTTP 503 Service Unavailable** responses using a combination of:

- **Header injection** — spoof trusted proxy/internal IP headers (`X-Forwarded-For`, `CF-Connecting-IP`, `True-Client-IP`, etc.)
- **Path normalization tricks** — URL encoding, double-encoding, dot-segment confusion (`%2f`, `/.`, `%252f`, `..;/`)
- **Protocol-level probing** — HTTP/1.0 downgrade, cache busting, `Retry-After: 0` header reset
- **Upstream cache manipulation** — vary-header stripping, stale cache forcing

Useful for pentesters and bug bounty hunters who hit maintenance pages, rate-limit walls, or CDN-enforced 503s that shouldn't apply to them.

---

## ⚙️ Requirements

```bash
bash >= 4.0
curl
```

No external dependencies. Just bash and curl.

---

## 🚀 Installation

```bash
git clone https://github.com/yourusername/bypass-503
cd bypass-503
chmod +x bypass-503.sh
```

---

## 🔧 Usage

```bash
./bypass-503.sh <URL>
```

### Examples

```bash
# Basic usage
./bypass-503.sh https://target.com/admin

# With a path that's returning 503
./bypass-503.sh https://target.com/api/v2/users

# Maintenance page bypass
./bypass-503.sh https://target.com/checkout
```

---

## 📸 Sample Output

```
 [*] HTTP 503 Bypass Tool | v2.1.3
 [*] Techniques: 16 headers + path fuzzing

 [INF] Target  : https://target.com/admin
 [INF] Started : Fri Aug 14 19:00:00 2026

 [*] Phase 1/3 — Header rotation...
  [████████████████████] 80%  Retry-After: 0

 [*] Phase 2/3 — Path normalization...
  [█████████████] 65%  https://target.com/%ef%bc%8f

 [*] Phase 3/3 — Protocol downgrade + cache probe...
  [█████] 25%  probing layer 5

 [!] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 [!]  [Critical] 503 has been bypassed check https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status
 [!] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 [+] Done. Elapsed: 2s
```

---

## ⚠️ Disclaimer

This tool is intended for **authorized security testing and educational purposes only**.  
Only use it against systems you own or have explicit written permission to test.  
The author is not responsible for any misuse or damage caused by this tool.

---

## 📄 License

[MIT](LICENSE) © 2026
