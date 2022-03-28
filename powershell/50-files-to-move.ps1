$sourceFolder = "C:\Users\rpost\Desktop\rpost-test\source"
$destinationFolder = "C:\Users\rpost\Desktop\rpost-test\gate"
$intakedrop_location = "C:\Users\rpost\Desktop\rpost-test\intake"
$backup_location = "C:\Users\rpost\Desktop\rpost-test\backup"
$maxItems = 50
$folder = Get-Childitem $sourceFolder | Select-Object -First $maxItems 

 foreach ($file in $folder) {
echo $file
Copy-Item $sourceFolder\$file $destinationFolder -Verbose
}

echo "ranameing file to eml"
Get-ChildItem -Path $destinationFolder -Recurse | Rename-Item -NewName {$_.name -replace "gate21.r1.rpost.net","eml"}
(Get-ChildItem -Path $destinationFolder -Recurse | Measure-Object).Count
echo "intake"
(Get-ChildItem -Path $intakedrop_location -Recurse | Measure-Object).Count
Copy-Item $gate_location\*.eml.txt -Destination $intakedrop_location -Verbose
echo "after files moved to intake"
(Get-ChildItem -Path $intakedrop_location -Recurse | Measure-Object).Count
Move-Item $gate_location\*.eml.txt -Destination $backup_location -Verbose
(Get-ChildItem -Path $intakedrop_location -Recurse | Measure-Object).Count
