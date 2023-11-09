# Function to get access token using v2 endpoint
function Get-AccessToken {
    param (
        [string]$clientId,
        [string]$clientSecret,
        [string]$tenantId
    )

    $scope = "https://graph.microsoft.com/.default"
    $authority = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

    $Body = @{
        "grant_type"    = "client_credentials"
        "client_id"     = $clientId
        "client_secret" = $clientSecret
        "scope"         = $scope
    }

    # Get AccessToken
    $result = Invoke-RestMethod -Method Post -Uri $authority -Body $Body
    $AccessToken = $result.access_token
    
    return $AccessToken
}

# Function to send email using Microsoft Graph API
function Send-Email {
    param (
        [string]$accessToken,
        [string]$recipientEmail,
        [string]$subject,
        [string]$body,
        [string]$fromUserIdOrUpn
    )

    $graphApiEndpoint = "https://graph.microsoft.com/v1.0/users/$fromUserIdOrUpn/sendMail"
    $headers = @{
        Authorization = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }

    $emailData = @{
        message = @{
            subject = $subject
            body = @{
                contentType = "Text"
                content = $body
            }
            toRecipients = @(
                @{
                    emailAddress = @{
                        address = $recipientEmail
                    }
                }
            )
            from = @{
                emailAddress = @{
                    address = $fromUserIdOrUpn
                }
            }
        }
    }

    $emailJson = $emailData | ConvertTo-Json -Depth 100
    Invoke-RestMethod -Uri $graphApiEndpoint -Method Post -Headers $headers -Body $emailJson -ContentType "application/json"
}

#E-Mail Configuration
$recipientEmail = "" 
$fromUserIdOrUpn = "" 

$subject = "Test Email from PowerShell"
$body = "This is a test email sent from PowerShell using Microsoft Graph API."


#Authentication 
$clientId = ""
$clientSecret = "" 
$tenantId = ""


# Main script
try {
    # Get the access token
    $accessToken = Get-AccessToken -clientId $clientId -clientSecret $clientSecret -tenantId $tenantId

    # Send the email
    Send-Email -accessToken $accessToken -recipientEmail $recipientEmail -subject $subject -body $body -fromUserIdOrUpn $fromUserIdOrUpn

    Write-Host "Email sent successfully!"
}
catch {
    Write-Host "Failed to send email: $($_.Exception.Message)"
    Write-Host "Response content: $($_.Exception.Response.GetResponseStream())"
}
