$Drives = Get-PSDrive -PSProvider 'FileSystem'

foreach($Drive in $drives) {

    #counts files in given directory

    Get-ChildItem -Path $Drive.Root -Filter *.eml.txt -Recurse  -ErrorAction SilentlyContinue | %{$_.FullName} `
    | Split-Path -Parent |Sort-Object | Get-Unique

}