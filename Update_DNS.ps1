clear
$File_Config="$PSScriptRoot\config.json"
$Config = (Get-Content -Path $File_Config -Raw) | ConvertFrom-Json
$url = "https://api.cloudflare.com/client/v4/zones/$($config.zone_id)/dns_records"
#$zoneid = $config.zone_id; 
#$token = $config.auth_key;
$header = @{"Authorization" = "Bearer $($config.auth_key)"}

##### Check if Folder Exist of the last run for debug
$Folder = "$PSScriptRoot\Logs"
if (!(Test-Path $Folder)) {
    New-Item -ItemType Directory -Path Logs | Out-Null
}


##### updateCloudflare.log file of the last run for debug
$File_LOG = "$PSScriptRoot\Logs\Cloudflare_Update_$(Get-Date -F 'dd-mm-yyyy hh.mm.ss').log"

$DATE=Get-Date -UFormat "%Y/%m/%d %H:%M:%S"
function Write-Log {
    Param ($Text)
    Write-Host $Text
    Add-Content -Path $File_LOG -Value ($DATE + "," + $Text)
}

 $subdomain =  $(Write-Host "Please, Input Sub-Domain: " -ForegroundColor Green -BackgroundColor Black -NoNewline; Read-Host)
 $hostname = $subdomain+"."+$config.domain
 #$ip = (Invoke-WebRequest -uri "https://ifconfig.io/ip").content  #Your Public IP 


 # Fetch the record information
 $record_data = Invoke-RestMethod -Method get -Uri "$url/?name=$hostname" -Headers $header
 Write-Host "`nCurrent DNS Entry." -ForegroundColor Yellow -BackgroundColor Black
 Write-Log  "Current DNS Entry."
 $record_data.result | Tee-Object $File_LOG -Append
 $type= "full"


 # Check if Existing Record is Available
 if ($record_data.result.id -eq $null) {
   Write-Host "`nMentioned DNS Entry is Not Available. Exiting Script." -ForegroundColor Blue -BackgroundColor Yellow
   exit
}
else
{

 # Fetch the record information
 $record_data = Invoke-RestMethod -Method get -Uri "$url/?name=$hostname" -Headers $header

 # Modify the IP from the fetched record
 $record_ID = $record_data.result[0].id
 $ip =  $(Write-Host "Please, Input DNS IP/Domain: " -ForegroundColor Red -BackgroundColor Black -NoNewline; Read-Host)
 $record_data.result[0].content = $ip
 #$record_data.result[0].content = (Invoke-WebRequest -uri "https://ifconfig.io/ip").content #Your Public IP 
 $body = $record_data.result[0] | ConvertTo-Json
 

 # Update the record
 $result = Invoke-RestMethod -Method put -Uri "$url/$record_ID" -Headers $header -Body $Body -ContentType "application/json"

     Write-Host ""
     Write-Host "Modified DNS Entry." -ForegroundColor Green -BackgroundColor Black 
     Write-Log "Modified DNS Entry.`n"
     $result.result | Tee-Object $File_LOG -Append

   
     
 }