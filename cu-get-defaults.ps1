$apiVersion = "2025-11-01"
$cuFoundryURL="<REPLCAE with your Foundry endpoint URL>"

$token = az account get-access-token --resource "https://cognitiveservices.azure.com" --query accessToken -o tsv

$headers = @{
    "Authorization" = "Bearer $token"
}

$response = Invoke-RestMethod -Uri "$cuFoundryURL/contentunderstanding/defaults?api-version=$apiVersion" -Method Get -Headers $headers
$response | ConvertTo-Json -Depth 10

