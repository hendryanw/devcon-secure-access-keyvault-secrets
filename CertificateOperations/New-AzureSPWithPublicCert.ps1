###  Create new service principal using certificate.

param (
    [Parameter(Mandatory=$true)]
    [String] $PublicCertFilePath,
    
    [String] $ServicePrincipalName
)

$ErrorActionPreference = "STOP"

# Convert the certificate into base64 string representation.
$x509cer = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$x509cer.Import($PublicCertFilePath)
$cerValue = [System.Convert]::ToBase64String($x509cer.GetRawCertData())

# Create new service principal using the certificate.
$sp = New-AzureRMADServicePrincipal -DisplayName $ServicePrincipalName -CertValue $cerValue -EndDate $x509cer.NotAfter -StartDate $x509cer.NotBefore

# Wait for the result
Start-Sleep 20
Write-Host "Certificate Thumbprint:" $x509cer.Thumbprint
Write-Output $sp