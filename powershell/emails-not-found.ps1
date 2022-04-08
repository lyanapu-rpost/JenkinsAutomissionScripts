$Path = "N:\IDrive\intake"
$init_path = "D:\TESTJOB_RCS_new_build\init.txt"
$init2_path = "D:\TESTJOB_RCS_new_build\init2.txt"
$init3_path = "D:\TESTJOB_RCS_new_build\init3.txt"
$reprocessed_file = "D:\TESTJOB_RCS_new_build\reprocessed_file.txt"
$filenotfound = "D:\TESTJOB_RCS_new_build\filenotfound.txt"
$emailnotsent = "D:\TESTJOB_RCS_new_build\emailnotsent.txt"

$SQLServer = "db41.qa.rpost.net"
$db3 = "rpost"

Clear-Content "$init_path"
Clear-Content "$init2_path"
Clear-Content "$init3_path"
Clear-Content "$reprocessed_file"
Clear-Content "$filenotfound"
Clear-Content "$emailnotsent"

Get-Item $Path\*.eml | Foreach {
$lastupdatetime=$_.LastWriteTime
$nowtime = get-date

if (($nowtime - $lastupdatetime).totalhours -le 100)
{
Write-Host "File modified within 1 hours "$_.name
Add-Content -Path $init_path -Value $_.name
}
else
{
Write-Host "File modified before 1 hours"
}
}
echo "messageid to init text"

$emllist_path = get-content "$init_path"

foreach ($file_path in $emllist_path) {

$result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Username "Webapiuser" -Password "#Rpost2015!" -Query @"
Select DISTINCT FileName from MessageFiles where FileName = '$file_path' 
"@

$result_2 = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Username "Webapiuser" -Password "#Rpost2015!" -Query @"
Select MessageId from Messages M With (Nolock), Destinations D With (Nolock), DestinationContexts C With (Nolock) 
Where M.MessageID = D.Message_MessageID ANd D.DestinationContext_DestinationContextId = C.DestinationContextId 
ANd C.Sent =0
And FileName = '$file_path'
"@

echo $result_2
echo $file_path
echo $result

$string = [string]::IsNullOrWhitespace($result)
$string_2 = [string]::IsNullOrWhitespace($result_2)

if ($string -eq $false){
echo "string is not null"
if (Compare-Object $file_path $result)
{
echo "file was there" $result
if ($string_2 -eq $true){
echo "email status sent" $file_path
}
else{
echo "email not sent" $file_path
Add-Content -Path $emailnotsent -Value $file_path
}
}
else {
echo "file not there" $file_path
Add-Content -Path $init2_path -Value $file_path
}
}

else {
echo "string empty"
Add-Content -Path $init2_path -Value $file_path
}

}

get-content "$init2_path" | % {$_ -replace "#",""} | Out-File $init3_path

gc $init3_path | get-unique > $reprocessed_file

$emllist2_path = get-content "$reprocessed_file"

foreach ($file2_path in $emllist2_path) {
$result2 = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Username "Webapiuser" -Password "#Rpost2015!" -Query @"
Select DISTINCT FileName from MessageFiles where FileName = '$file2_path' 
"@

$result_3 = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Username "Webapiuser" -Password "#Rpost2015!" -Query @"
Select MessageId from Messages M With (Nolock), Destinations D With (Nolock), DestinationContexts C With (Nolock) 
Where M.MessageID = D.Message_MessageID ANd D.DestinationContext_DestinationContextId = C.DestinationContextId 
ANd C.Sent =0
And FileName = '$file2_path'
"@

echo $file2_path
echo $result2
$string2 = [string]::IsNullOrWhitespace($result2)
$string_3 = [string]::IsNullOrWhitespace($result_3)
if ($string2 -eq $false){
echo "string2 is not null"
if (Compare-Object $file2_path $result2)
{
echo "file was there 2" $result2
if ($string_3 -eq $true){
echo "email status sent" $file2_path
}
else{
echo "email not sent" $file2_path
Add-Content -Path $emailnotsent -Value $file2_path
}
}
else {
echo "file not there $file2_path"
Add-Content -Path $filenotfound -Value $file2_path
}
}
else {
echo "string empty"
Add-Content -Path $filenotfound -Value $file2_path
}
}