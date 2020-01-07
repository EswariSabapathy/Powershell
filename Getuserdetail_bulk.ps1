#param($p1)
#$Script:args=""
$FileName = "<File_location>\Filename.csv"
$username = "userid@domain.com"

$pass = convertto-securestring (get-content secstring.txt) -key (1..16)
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass
Connect-MsolService -Credential $cred
Connect-AzureAD -Credential $cred
$i=0

Get-Content -Path $FileName |ForEach-Object  {
   #$Script:args+= "`$$key=" + $PSBoundParameters["$key"] + "  "
    $i++ 
     $user = Get-AzureADUser -Filter "userPrincipalName eq '$_'"
   $email = $user.mail
    
    #return $PSBoundParameters["$key"];
   
    $userdetail = $(Get-MsolUser -UserPrincipalName $_).StrongAuthenticationUserDetails 
   
   $valuesUser = $userdetail | Select-Object -Property Email,AlternativePhoneNumber,PhoneNumber 
   

  $methods = $(Get-MsolUser -UserPrincipalName $_).StrongAuthenticationMethods 
  $authmethods = $methods |Select-Object -Property MethodType
   Write-Host $authmethods
 
   $_ +","+$valuesUser+","+$authmethods >> 000-BTSS_output.csv
   if($valuesUser)
   {

    $_ +","+$email+","+"Yes"+$authmethods >> 000-BTSS_EnrollmentStatus.csv
    }
    else
    {
     $_ +","+$email+","+"No" +$authmethods >> 000-BTSS_EnrollmentStatus.csv
    }

  # Write-Host  $_ +","+$valuesUser+","+$authmethods
 }
 #write-host "MFA details of user" $Script:args "are " $userdetail

