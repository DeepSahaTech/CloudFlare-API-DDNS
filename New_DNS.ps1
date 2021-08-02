clear
$File_Config = "$PSScriptRoot\config.json"
$config = (Get-Content -Path $File_Config -Raw) | ConvertFrom-Json
#$zoneid = $config.zone_id; 
#$token = $config.auth_key;

##### Check if Folder Exist of the last run for debug
$Folder = "$PSScriptRoot\Logs"
if (!(Test-Path $Folder)) {
    New-Item -ItemType Directory -Path Logs | Out-Null
}
##### updateCloudflare.log file of the last run for debug
$File_LOG = "$PSScriptRoot\Logs\Cloudflare_New_$(Get-Date -F 'dd-mm-yyyy hh.mm.ss').log"

$DATE=Get-Date -UFormat "%Y/%m/%d %H:%M:%S"
function Write-Log {
    Param ($Text)
    Write-Host $Text
    Add-Content -Path $File_LOG -Value ($DATE + "," + $Text)
}



$url = "https://api.cloudflare.com/client/v4/zones/$($config.zone_id)/dns_records"
$subdomain =  $(Write-Host "Input Sub-Domain (Alias): " -ForegroundColor Green -BackgroundColor Black -NoNewline; Read-Host)
$hostname = $subdomain+"."+$config.domain
$header = @{"Authorization" = "Bearer $($config.auth_key)"}

# Check if Existing Record is Available
 $existing_data = Invoke-RestMethod -Method get -Uri "$url/?name=$hostname" -Headers $header
 Write-Log "Checking if Existing Sub-Domain is Already Available."
 $existing_data.result | Tee-Object $File_LOG -Append

  if ($existing_data.result.id -ne $null) {
  Write-Host "`nMentioned DNS Entry is Already Available. Exiting Script." -ForegroundColor Blue -BackgroundColor Yellow
  exit
}
else
{
	
# Adding New DNS Record
Write-Log "Existing Sub-Domain is not Available for "$subdomain" Creating New Sub-Domain"
$ip =  $(Write-Host "Input DNS IP/Domain: " -ForegroundColor Red -BackgroundColor Black -NoNewline; Read-Host)
#$ip = (Invoke-WebRequest -uri "https://ifconfig.io/ip").content  #Your Public IP 
$type = $(Write-Host "Input DNS Type (A/CNAME): " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Read-Host)
$body = @{"type" = $type; "name" = $hostname; "content" = $ip; "proxied" = $false }
$body = $body | ConvertTo-Json

$result = Invoke-RestMethod -Method post -Uri $url -Headers $header -Body $body -ContentType "application/json"

 $result.result | Tee-Object $File_LOG -Append
 $result = $null
 $existing_data = $null

 }

