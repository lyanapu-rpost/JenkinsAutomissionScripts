$Path = "N:\IDrive\intake"
$init_path = "D:\TESTJOB_RCS_new_build\init.txt"
$init2_path = "D:\TESTJOB_RCS_new_build\init2.txt"
$SQLServer = "db41.qa.rpost.net"
$db3 = "rpost"
$fromdate = (get-date).ToString("yyyy-MM-dd HH:mm:ss")
$todate = (Get-Date).AddHours(-1).ToString("yyyy-MM-dd HH:mm:ss")

Clear-Content "$init_path"
Clear-Content "$init2_path"

Get-Item $Path\*.eml | Foreach {
$lastupdatetime=$_.LastWriteTime
$nowtime = get-date

if (($nowtime - $lastupdatetime).totalhours -le 48)
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
#echo $file_path
#echo "sql query"

$result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Username "Webapiuser" -Password "#Rpost2015!" -Query @"
Select DISTINCT FileName from MessageFiles where FileName = '$file_path' 
"@
echo $file_path
echo $result
$string = [string]::IsNullOrWhitespace($result)
if ($string -eq $false){
echo "string is not null"
if (Compare-Object $file_path $result)
{
echo "file was there $result"

}
else {
echo "file not there $file_path"
Add-Content -Path $init2_path -Value $file_path
}
}
else {
echo "string empty"
Add-Content -Path $init2_path -Value $file_path
}
}
