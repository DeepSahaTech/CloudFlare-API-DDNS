# 🚀 CloudFlare-API-DDNS<br><br>

<p align="center"><a href="" target="_blank" rel="noopener noreferrer"><img width="1024" src="graphic.jpg" alt="Cloudflare DDNS"/></a></p>


This repository consist of 3 Powershell Scripts to perform various task in Cloudflare DDNS.<br>
Using this script you can update, add new DNS record for a domain in Cloudflare using Cloudflare API.<br><br><br>

### 📁 Files<br>

```Check_DNS.ps1``` This Script will help to check if config.json file is properly configured and Script can connect successfully using Cloudflare API. <br>
```New_DNS.ps1``` This Script is used to Create a NEW DNS Record in CloudFlare Domain using API.<br>
```Update_DNS.ps1``` This Script is used to Update an Existing DNS Record in CloudFlare Domain using API.<br>
```Config.json``` This file have to be edited to include API Token, Domain and Domain ID.<br><br><br>

### 🔑 Authentication<br>

This script uses new API Token authentication method which is secure.
To generate a new API tokens, go to your [Cloudflare Profile](https://dash.cloudflare.com/profile/api-tokens) and create a token capable of **Edit DNS**. Then replace the value in

⚡ How to Run The Script<br>

1. Modify config.json with required details<br>
    ```"domain": "Domain Name"```    <== This field should be edited with the domain name associated with Cloudflare<br>
    ```"auth_key": "API Token"```    <== This field should be edited with the API Token associated with Cloudflare<br>
    ```"zone_id": "Zone ID"```       <== This field should be edited with the Zone ID / Domain ID associated with Cloudflare<br>
2. Run ```Check_DNS.ps1``` to check if API Connection is Successful.
3. Run ```New_DNS.ps1``` OR ```Update_DNS.ps1``` depending on your requirement.
                                              
