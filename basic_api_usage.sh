# Curl basic API usage
BASE_URL=https://station.trustar.co
resp=$(curl -s -k -u ${TRUSTAR_API_KEY}:${TRUSTAR_API_SECRET} -d "grant_type=client_credentials" ${BASE_URL}/oauth/token)
token=$(printf $resp |  jq -r .access_token)

# Indicator query
curl -k -H "Authorization: Bearer ${token}" "${BASE_URL}/api/v1/indicators?q=1.2.3.4&limit=3"

# Multiple enclave submission
resp=$(curl -s -k -H "Content-Type: application/json" -X POST \
	 -d '{"incidentReport":{"title":"curl api-report test","timeDiscovered":"2016-08-01T11:38:35+00:00",
	 "reportBody":"This is a test report body with some indicators: 1.2.3.4, evil.exe, api.evildomain.com, hash d2dd1bcdd6d6cfac59ba9638d2cd886c",
	 "distributionType":"ENCLAVE"}, "enclaveIds":["b93f6d70-1787-4853-8768-0cb2377bfaf7"]}' \
	 -H "Authorization: Bearer ${token}" ${BASE_URL}/api/v1/reports/submit)

echo $resp