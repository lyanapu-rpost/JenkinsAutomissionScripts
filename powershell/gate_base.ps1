$ErrorActionPreference = 'Stop'
$source_location = Read-Host -Prompt 'enter source location'
$destination_location = Read-Host -Prompt 'enter destination location'
$gate =  Read-Host -Prompt 'enter gate number'
echo $source_location
(Get-ChildItem -Path $source_location -Recurse | Measure-Object).Count
echo $destination_location
(Get-ChildItem -Path $destination_location -Recurse | Measure-Object).Count
if ( 21 -eq $gate )
{
echo "running on gate21 files"
echo "moveing source location to backup"
Copy-Item $source_location\*.* -Destination $destination_location -Verbose
echo "destination file count"
(Get-ChildItem -Path $destination_location -Recurse | Measure-Object).Count
echo "ranameing file to eml"
Get-ChildItem -Path $destination_location -Recurse | Rename-Item -NewName {$_.name -replace "gate21.r1.rpost.net","eml"}
(Get-ChildItem -Path $destination_location -Recurse | Measure-Object).Count
}
if ( 22 -eq $gate )
{
echo "running on gate 22 files"
Copy-Item $source_location\*.* -Destination $destination_location -Verbose
echo "destination file count"
(Get-ChildItem -Path $destination_location -Recurse | Measure-Object).Count
echo "ranameing file to eml"
Get-ChildItem -Path $destination_location -Recurse | Rename-Item -NewName {$_.name -replace "gate22.r1.rpost.net","eml"}
(Get-ChildItem -Path $destination_location -Recurse | Measure-Object).Count
}
echo files copied
Start-sleep -Seconds 30
Read-Host -Prompt “Press Enter to exit”