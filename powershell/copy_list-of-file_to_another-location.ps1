$list = get-content "C:\Users\rpost\Desktop\rpost-test\file_list.txt"
$path = get-content "C:\Users\rpost\Desktop\rpost-test\path_list.txt"
$destination = "C:\Users\rpost\Desktop\rpost-test2"
 foreach ($service_path in $path) {
    foreach ($service_list in $list){
    echo $service_path$service_list
    #$Tpath = Test-Path $service_path$service_list -PathType Leaf

    Copy-Item $service_path$service_list -Destination $destination -Verbose

    }
 }
 