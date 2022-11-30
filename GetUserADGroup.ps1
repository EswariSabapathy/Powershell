$users=get-content "C:\Users\<userid>\Documents\Scripts\GetUserADGroup\input.csv"
foreach($user in $users){
$groups =@()

#$users = get-adgroupmember -identity $grp 
$groups = (Get-ADUser $user –Properties MemberOf).memberof

$resultsarray =@()
foreach ($group in $groups) {

       $groupobject = new-object PSObject
      
       
         $g = Get-ADGroup $group -Properties * | Select-Object name,description,managedby,title
         
          $groupobject | add-member  -membertype NoteProperty -name "Name" -Value $g.name
           $groupobject | add-member  -membertype NoteProperty -name "Description" -Value $g.description
     
       
       $resultsarray += $groupobject
}
if($resultsarray -ne $null)
{
$resultsarray | Export-Csv -Encoding UTF8  -Delimiter "," -Path "C:\Users\<userid>\Documents\Scripts\GetUserADGroup\result\$user.csv" -NoTypeInformation
}
}