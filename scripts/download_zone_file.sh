zone=$1
token=$2
curl --request GET --url https://api.cloudflare.com/client/v4/zones/$zone/dns_records/export --header 'Content-Type: application/json' --header "Authorization: Bearer $token"