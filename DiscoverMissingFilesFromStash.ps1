<# 
AUTHOR
    JuiceBox

DESCRIPTION
    This script takes a provided directory and checks to see if you have missing media from your Stash database for that directory

REQUIREMENTS
    This script requires the Powershell module "PSSQLite" https://github.com/RamblingCookieMonster/PSSQLite
    From the respository linked above, download a zip of the PSSQlite folder. Extract it wherever you like.
    In the folder you extracted PSSQLite to, open a Powershell prompt (in Administrative mode) in that directory
    Run the command install-module pssqlite followed by the command import-module pssqlite 
#>

    $PathToStashDatabase = "C:\REPLACEME\Stash\db\stash-go.sqlite" # <- Please set this to the correct path for your environment

    clear-host
    if ($PathToStashDatabase -eq "C:\REPLACEME\Stash\db\stash-go.sqlite"){
        read-host "Error: You need to modify line 15 of this script and enter the path to your Stash Database file. Press [Enter] to exit"
        exit
    }
    write-host "This script takes a provided directory and checks to see if you have missing media from your Stash database for that directory."
    $pathtomedia = read-host "Enter the directory you would like to scan"
    read-host "OK, press [Enter] to begin searching"
    
    $mediafiles = Get-ChildItem -recurse -path $pathtomedia\* -Include *.m4v, *.mp4, *.mov, *.wmv, *.avi, *.mpg, *.mpeg, *.rmvb, *.rm, *.flv, *.asf, *.mkv, *.webm
    $missingcounter = 0
    
    #Iterating through our collection and querying Stash's database for those paths
    foreach ($media in $mediafiles){
        $Query = "SELECT path FROM scenes WHERE scenes.path = '"+$media.fullname+"'"
        $StashDB_QueryResult = Invoke-SqliteQuery -Query $Query -DataSource $PathToStashDatabase
        
        #Looks like we didn't find a matching file. Alert the user, move on.
        if (!$StashDB_QueryResult){
            write-host "`nThe following media file is on your filesystem but is not in your Stash database" -ForegroundColor Cyan
            write-host $media.fullname
            Add-Content -Path FilesMissingFromStash.txt -value $media.fullname
            $missingcounter++
        }
    }
    $numDiscoveredfilesonfilesystem = $mediafiles.Length
    $Query = "SELECT COUNT(*) FROM scenes WHERE scenes.path like'"+$pathtomedia+"%'"
    $numDiscoveredFilesInStash = Invoke-SqliteQuery -Query $Query -DataSource $PathToStashDatabase
    
    write-host "`n---"
    write-host "$missingcounter files were discovered that are present on your filesystem but are not in your Stash database."
    write-host "The total number of media files on your filesystem with the provided directory is: $numDiscoveredfilesonfilesystem"
    write-host "The total number of media files in your Stash database with the provided directory is:" $numDiscoveredFilesInStash.'COUNT(*)'