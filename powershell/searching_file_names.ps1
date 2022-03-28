$list = get-content "C:\Users\rpost\Desktop\rpost-test\file_list.txt"
$path = get-content "C:\Users\rpost\Desktop\rpost-test\path_list.txt"
$outputfile = "C:\Users\rpost\Desktop\rpost-test"
 foreach ($service_path in $path) {
    foreach ($service_list in $list){
    echo $service_path$service_list
    $Tpath = Test-Path $service_path$service_list -PathType Leaf

    if(Test-Path $service_path$service_list ) {
    Write-Host "file exist $service_path$service_list"
    Add-Content $outputfile\files_exists_list.txt  "$service_path$service_list" 
    }
    Else {
    Write-Host "file does not exist $service_path$service_list"
    Add-Content $outputfile\files_not-sorted-exists_list.txt  "$service_list"
    }
    }
 }
 gc $outputfile\files_not-sorted-exists_list.txt | sort | Get-unique > files_not_exist_list.txt
 