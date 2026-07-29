#!/usr/bin/env sh
set -eu

# Read credentials from the environment so the token never appears in the
# process list (argv is world-readable via /proc on the runner).
zone="${CLOUDFLARE_ZONE:?CLOUDFLARE_ZONE not set}"
token="${CLOUDFLARE_TOKEN:?CLOUDFLARE_TOKEN not set}"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# Fetch the BIND zone export.
#   --fail-with-body : exit non-zero on HTTP >= 400 but still capture the body
#                      so we can log Cloudflare's error message.
#   --retry ...      : ride out transient 5xx / network blips.
#   --connect-timeout / --max-time : never hang a scheduled job forever.
#
# Capture the status code (--write-out) in http_code while the body goes to
# $tmp (--output); the trailing || block runs only if curl exits non-zero.
http_code="$(
  curl --silent --show-error --location \
       --fail-with-body \
       --retry 5 --retry-delay 5 --retry-all-errors \
       --connect-timeout 30 --max-time 300 \
       --write-out '%{http_code}' \
       --request GET \
       --url "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records/export" \
       --header 'Content-Type: application/json' \
       --header "Authorization: Bearer ${token}" \
       --output "$tmp"
)" || {
  echo "download_zone_file: curl failed (HTTP ${http_code:-none})" >&2
  cat "$tmp" >&2 2>/dev/null || true
  exit 1
}

# Cloudflare returns raw BIND text on success and a JSON envelope ONLY on error.
# Reject the envelope even if it somehow arrived with HTTP 200.
if [ "$(head -c 1 "$tmp")" = "{" ] || grep -q '"success":[[:space:]]*false' "$tmp"; then
  echo "download_zone_file: API returned an error envelope, not a zone file:" >&2
  cat "$tmp" >&2
  exit 1
fi

# Sanity floor: the real .gov zone is thousands of lines. Anything
# tiny means a truncated / bogus response, so refuse it rather than publish it.
lines="$(wc -l < "$tmp")"
if [ "$lines" -lt 1000 ]; then
  echo "download_zone_file: response only ${lines} lines; refusing (looks truncated)" >&2
  cat "$tmp" >&2
  exit 1
fi

# Strip Cloudflare proxy tags, then emit the cleaned zone file on stdout.
sed 's/[[:blank:]]*; cf_tags=cf-proxied:false//g' "$tmp"
