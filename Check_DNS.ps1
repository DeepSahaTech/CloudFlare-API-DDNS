$File_Config="$PSScriptRoot\config.json"
$Config = (Get-Content -Path $File_Config -Raw) | ConvertFrom-Json
#$token = $config.auth_key;
Invoke-RestMethod -Method Get -Uri "https://api.cloudflare.com/client/v4/user/tokens/verify" -Headers @{
 "Authorization" = "Bearer $($config.auth_key)"
 "Content-Type" = "application/json"
 } 