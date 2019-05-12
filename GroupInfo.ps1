
# defines search term 
$SearchTerm = "cfg_proxy_*"

# searched for AD groups meeting search term 
$Groups = get-adgroup -Filter * | where {$_.name -like $searchTerm}

# Loops through list gathering data
$Results = foreach ($Group in $Groups) {

   # sets variables
   $Name = $Group.name
   $Description = (get-adgroup $Group -Properties description).description
   $Samaccountname = $Groups.SamAccountName
   $Count = (Get-ADGroupmember $Group | Measure-Object).count

    # creates a custom object containing the data 
    [pscustomobject]@{

            Name = $Name
            Samaccountname = $Samaccountname 
            Description = $Description
            NumberOfMembers = $Count
            
            }
   

    } 

# outputs the results 
$Results





