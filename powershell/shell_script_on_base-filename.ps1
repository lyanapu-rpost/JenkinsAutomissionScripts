move the file 

#!/bin/bash
source_folder1='/path/'
destinationFolder2='/path/'
backup_folder3='/path/'
ls $source_folder1 > sourtce_list.txt
echo 'source file count'

ls $source_folder1 | wc -l
sleep 3s
cp $source_folder1\*.* $backup_folder3
sleep 3s
mv $source_folder1\*.* $destinationFolder2
echo 'destination file count'
ls $destinationFolder2 | wc -l

cd $source_folder1

