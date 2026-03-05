$baseUrl = "<REPLCAE with your Foundry endpoint URL>"

$apiVersion = "2025-11-01"
$analyzerId = "myReceipt"

$token = az account get-access-token --resource "https://cognitiveservices.azure.com" --query accessToken -o tsv

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json"
}

$body = @{
    analyzerId     = $analyzerId
    baseAnalyzerId = "prebuilt-document"
    models = @{
        completion = "gpt-4o"
        embedding  = "text-embedding-3-large"
    }
    config = @{}
} | ConvertTo-Json -Depth 5

$response = Invoke-RestMethod -Uri "$baseUrl/contentunderstanding/analyzers/${analyzerId}?api-version=$apiVersion" -Method Put -Headers $headers -Body $body
$response | ConvertTo-Json -Depth 10
