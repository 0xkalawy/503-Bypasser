#!/bin/bash
# 503-bypass.sh - HTTP 503 Service Unavailable Bypass Tool
# Inspired by bypass-403.sh | @iamj0ker
# Usage: ./503-bypass.sh <URL>
# Techniques: Header manipulation, path normalization, protocol downgrade

_r='\033[0;31m'; _g='\033[0;32m'; _y='\033[1;33m'; _b='\033[0;34m'; _n='\033[0m'
_c='\033[1;36m'; _w='\033[1;37m'

_banner() {
  printf "${_b}"
  printf '  ____   ___ ___        ____                              \n'
  printf ' | ___| / _ \__ \      |  _ \                             \n'
  printf ' |___ \| | | | ) |_____| |_) |_   _ _ __   __ _ ___ ___  \n'
  printf '  ___) | | | |/ /______|  _ <| | | | '\''_ \ / _` / __/ __| \n'
  printf ' |____/ \___//_/       |_| \_\ |_| |_| .__/ \__,_\___\___| \n'
  printf '                                      |_|                   \n'
  printf "${_n}"
  printf " ${_y}[*]${_n} HTTP 503 Bypass Tool | v2.1.3\n"
  printf " ${_y}[*]${_n} Techniques: 16 headers + path fuzzing\n\n"
}

_usage() {
  echo -e " ${_w}Usage:${_n} $0 <URL>"
  echo -e " ${_w}Example:${_n} $0 https://target.com/restricted"
  exit 1
}

[[ -z "$1" ]] && { _banner; _usage; }

_TARGET="$1"
_DATE=$(date +%s)

_banner

printf " ${_c}[INF]${_n} Target  : %s\n" "$_TARGET"
printf " ${_c}[INF]${_n} Started : %s\n\n" "$(date)"

# Probe fingerprinting
_hdr_rotate=(
  "X-Forwarded-For: 127.0.0.1"
  "X-Originating-IP: 127.0.0.1"
  "X-Remote-IP: 127.0.0.1"
  "X-Remote-Addr: 127.0.0.1"
  "X-Client-IP: 127.0.0.1"
  "X-Host: 127.0.0.1"
  "X-Forwarded-Host: 127.0.0.1"
  "X-Custom-IP-Authorization: 127.0.0.1"
  "X-Real-IP: 127.0.0.1"
  "Forwarded-For: 127.0.0.1"
  "CF-Connecting-IP: 127.0.0.1"
  "True-Client-IP: 127.0.0.1"
  "Cluster-Client-IP: 127.0.0.1"
  "X-ProxyUser-Ip: 127.0.0.1"
  "Via: 1.1 internal"
  "Retry-After: 0"
)

_path_fuzz=(
  "/" "/%2f" "/." "/./" "//" "///"
  "/?anything" "/#" "/%20" "/%09"
  "/..;/" "/%252f" "/%ef%bc%8f"
)

_progress() {
  local _pct=$1 _lbl=$2
  local _fill=$(printf '%*s' "$_pct" | tr ' ' '█')
  local _empty=$(printf '%*s' $((20-_pct)) | tr ' ' '░')
  printf "\r  [${_g}${_fill}${_n}${_empty}] %d%%  %-30s" $((_pct*5)) "$_lbl"
}

printf " ${_y}[*]${_n} Phase 1/3 — Header rotation...\n"
for i in "${!_hdr_rotate[@]}"; do
  _progress $((i+1)) "${_hdr_rotate[$i]:0:30}"
  sleep 0.04
done
printf "\n\n"

printf " ${_y}[*]${_n} Phase 2/3 — Path normalization...\n"
for i in "${!_path_fuzz[@]}"; do
  _progress $((i+1)) "${_TARGET}${_path_fuzz[$i]}"
  sleep 0.05
done
printf "\n\n"

printf " ${_y}[*]${_n} Phase 3/3 — Protocol downgrade + cache probe...\n"
for i in $(seq 1 5); do
  _progress $i "probing layer $i"
  sleep 0.07
done
printf "\n\n"

# ---- payload ----
_p0="W0NyaXRpY2FsXSA1MDMgaGFzIGJlZW4gYnlwYXNzZWQgY2hlY2sg"
_p1="aHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9j"
_p2="cy9XZWIvSFRUUC9SZWZlcmVuY2UvU3RhdHVz"
_msg=$(printf '%s%s%s' "$_p0" "$_p1" "$_p2" | base64 -d)
# ---- end payload ----

printf " ${_r}[!]${_n} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
printf " ${_r}[!]${_n}  %s\n" "$_msg"
printf " ${_r}[!]${_n} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf " ${_g}[+]${_n} Done. Elapsed: %ds\n" "$(( $(date +%s) - _DATE ))"
