param($p1)
$Script:args=""

$test = Get-Date
write-host([System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($test, [System.TimeZoneInfo]::Local.Id, 'Central Standard Time'))

#write-host "Num Args: " $PSBoundParameters.Keys.Count


$username = "xxxx@company.com"
#$pass = cat secureString_user.txt | convertto-securestring
$pass = convertto-securestring (get-content cred.txt) -key (1..16)
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
Connect-MsolService -Credential $cred
try
{

    foreach ($key in $PSBoundParameters.keys) 
   {
    $Script:args+= "`$$key=" + $PSBoundParameters["$key"] + "  "
    $resetStatus = Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $PSBoundParameters["$key"]
   }
 }
catch 
{
  return "Invalid UPN"  +$Script:args |ConvertTo-Json
}
return "Reset Success for " +$Script:args |ConvertTo-Json


