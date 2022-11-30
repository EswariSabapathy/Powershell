$groups=get-content "C:\Users\<userid>\Documents\Scripts\ADGroupMembership\input\input.csv"
foreach($grp in $groups){
$users =@()

#$users = get-adgroupmember -identity $grp 
$users =Get-ADGroupmember -Identity $grp  
#echo $users
#foreach ($user in $users)
#{
#echo  $user

 #Get-AdUser -identity $user | Select-object name,samaccountname,manager,enabled,department | Export-Csv -path C:\Users\aa_ekanagasabapathy\Documents\Scripts\ADGroupMembership\result\$grp.csv

#}
#Get-ADGroupMember -identity $grp | ? {$_.objectclass -eq 'user'}| foreach{ get-aduser -identity $_  -Properties *} | Select-Object SamAccountName,name,manager,department,enabled |Export-Csv -path C:\Users\aa_ekanagasabapathy\Documents\Scripts\ADGroupMembership\result\$grp.csv


$resultsarray =@()
foreach ($user in $users) {
 $UserObject = new-object PSObject
       $UserObject | add-member  -membertype NoteProperty -name "SamAccountName" -Value $user.SamAccountName
       
      
       if ($user.objectclass -eq 'user')
       {
         $u = get-aduser -identity $user  -Properties * | Select-Object manager,department,enabled,title
         
          $UserObject | add-member  -membertype NoteProperty -name "Department" -Value $u.department
           $UserObject | add-member  -membertype NoteProperty -name "StatusEnabled" -Value $u.enabled
           $UserObject | add-member  -membertype NoteProperty -name "Title" -Value $u.title
            $UserObject | add-member  -membertype NoteProperty -name "Manager" -Value $u.Manager
       }
       $resultsarray += $UserObject
}
if($resultsarray -ne $null)
{
$resultsarray | Export-Csv -Encoding UTF8  -Delimiter "," -Path "C:\Users\<userid>\Documents\Scripts\ADGroupMembership\result\$grp.csv" -NoTypeInformation
}
}