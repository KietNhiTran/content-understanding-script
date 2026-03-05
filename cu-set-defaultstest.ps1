$apiVersion = "2025-11-01"
$cuFoundryURL="<REPLCAE with your Foundry endpoint URL>"

$token = az account get-access-token --resource "https://cognitiveservices.azure.com" --query accessToken -o tsv

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json"
}

$body = @{
    modelDeployments = @{
        "gpt-4.1-mini" = "gpt-4.1-mini"
        "text-embedding-3-large" = "text-embedding-3-large"
        "gpt-4o" = "gpt-4o"
        "gpt-4.1" = "gpt-4.1-189637"

    }
} | ConvertTo-Json -Depth 5

$response = Invoke-RestMethod -Uri "$cuFoundryURL/contentunderstanding/defaults?api-version=$apiVersion" -Method Patch -Headers $headers -Body $body
$response | ConvertTo-Json -Depth 10

