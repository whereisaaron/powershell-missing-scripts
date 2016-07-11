<#
  Fetch a URI even if the SSL certificate does not match
  Aaron Roydhouse <aaron@roydhouse.com>, July 2016
  with thanks to HaIR
  https://connect.microsoft.com/PowerShell/feedback/details/419466/new-webserviceproxy-needs-force-parameter-to-ignore-ssl-errors
#>
param([System.Uri] $Uri)

# Ensure this PS session will not complain about SSL certificates
if (-not ([System.Management.Automation.PSTypeName]'TrustAllCertificatePolicy').Type)
{
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
	
    public class TrustAllCertificatePolicy : ICertificatePolicy
		{
        public bool CheckValidationResult(
            ServicePoint srvPoint, 
            X509Certificate certificate,
            WebRequest request, 
            int certificateProblem)
				{
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertificatePolicy
}

Invoke-WebRequest $Uri -UseBasicParsing
