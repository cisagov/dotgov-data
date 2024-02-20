"""Authenticates into ICANN using Github Actions secrets credentials and downloads .gov zone file"""
ICANN_username=$1
ICANN_password=$2
authentication_data="{\"username\":\"$ICANN_username\",\"password\":\"$ICANN_password\"}"
token=$(curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" -d $authentication_data https://account-api.icann.org/api/authenticate | jq -r .accessToken)
curl -X GET --output gov.zone.txt.gz -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token" https://czds-api.icann.org/czds/downloads/gov.zone