#!/usr/bin/env zsh
#
# Builds a unified CA cert bundle so NODE_EXTRA_CA_CERTS can point to one
# authoritative file instead of being clobbered by each app's install script.
#
# ── HOW TO ADD A CERT SOURCE ─────────────────────────────────────────────────
#   When a new app hijacks NODE_EXTRA_CA_CERTS with only its own cert, add
#   its path to CERT_SOURCES below and re-run this script.
#   Missing files are skipped with a warning — nothing is fatal.
# ─────────────────────────────────────────────────────────────────────────────
#
# Usage:  bin/cert-bundle.sh

DEV_ROOT_CRT="$HOME/.tls/tempCA/sfdc-dev-root.crt"
DEV_ROOT_PEM="$HOME/.tls/tempCA/sfdc-dev-root.pem"
CERT_BUNDLE="$HOME/certificates/ca_bundle.pem"

# ── Add new entries here ──────────────────────────────────────────────────────
# Format: "Display Label|/absolute/path/to/cert.pem"
typeset -a CERT_SOURCES=(
  "SFDC Internal Root CA 3|$HOME/certificates/Salesforce_Internal_Root_CA_3.pem"
  "SFDC Internal Root CA 4|$HOME/certificates/Salesforce_Internal_Root_CA_4.pem"
  "Dev Local CA|$DEV_ROOT_PEM"
  "Claude Code|$HOME/.claude/certs/salesforce-ca-bundle.pem"
  "DevBar|$HOME/.devbar/certs/corporate-ca-bundle.pem"
  "AI Suite|$HOME/.aisuite/conf/npm-sfdc-certs.pem"
)
# ─────────────────────────────────────────────────────────────────────────────

if [[ -f "$DEV_ROOT_CRT" ]]; then
  echo "→ Converting local dev CA to PEM..."
  openssl x509 -in "$DEV_ROOT_CRT" -out "$DEV_ROOT_PEM" -outform PEM
fi

mkdir -p "$(dirname "$CERT_BUNDLE")"
rm -f "$CERT_BUNDLE"

added=0
skipped=0

echo "Building cert bundle: $CERT_BUNDLE"
for entry in "${CERT_SOURCES[@]}"; do
  label="${entry%%|*}"
  path="${entry##*|}"
  if [[ -f "$path" ]]; then
    printf '  + %s\n' "$label"
    /bin/cat "$path" >> "$CERT_BUNDLE"
    printf '\n' >> "$CERT_BUNDLE"
    (( added++ ))
  else
    printf '  - %s (not found: %s)\n' "$label" "$path"
    (( skipped++ ))
  fi
done

echo ""
echo "Done: $added cert(s) bundled, $skipped skipped."
echo "NODE_EXTRA_CA_CERTS should point to: $CERT_BUNDLE"
