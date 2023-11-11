# Generic script to get an OAuth token for a REST API

$authSuccess = $false
$authurl = "http://api_Identity_URL_Here/connect/token"
$clientId = "your_client_id"
$clientSecret = "your_client_secret"
$authboundary = [System.Guid]::NewGuid().ToString()
$authLF = "`r`n"
$authbodyLines = (
  "--$authboundary",
  "Content-Disposition: form-data; name=`"client_id`"$authLF",
  $clientId,
  "--$authboundary",
  "Content-Disposition: form-data; name=`"client_secret`"$authLF",
  $clientSecret,
  "--$authboundary",
  "Content-Disposition: form-data; name=`"grant_type`"$authLF",
  "client_credentials",
  "--$authboundary--"
) -join $authLF

try {
  $tokenResponse = Invoke-WebRequest -Uri $authurl -Method Post -ContentType "multipart/form-data; boundary=$authboundary" -Body $authbodyLines
  $tokenResponseJSON = ConvertFrom-Json $tokenResponse.Content

  # Extract the token from the response
  $tokenBearer = $tokenResponseJSON.token_type
  $token = $tokenResponseJSON.access_token
  $authSuccess = $true

  "Authorized. Token is: $token"
} catch {
  $authSuccess = $false
  "ERROR - Unable to get an access token."
}
