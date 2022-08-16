# DiscoverMissingFilesFromStash
This script takes a provided directory and checks to see if you have missing media from your Stash database for that directory

# Requirements
- The Powershell module "PSSQLite" must be installed https://github.com/RamblingCookieMonster/PSSQLite
* From the respository linked above, download a zip of the PSSQlite folder. Extract it wherever you like.
* In the folder you extracted PSSQLite to, open a Powershell prompt (in Administrative mode) in that directory
* Run the command `install-module pssqlite` followed by the command `import-module pssqlite`

# How to Run
- If you aren't on Windows (or are on anything older than Windows 10), install Powershell Core, available for Linux and macOS!
- Ensure you've installed PSSQLite as described in the section above
- Modify line 15 of the script so that the path to your Stash database is correct
- Run the script
