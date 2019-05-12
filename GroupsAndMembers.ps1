<#
.SYNOPSIS
  Script to show all members of AD groups meeting a specified search term
.DESCRIPTION
  Searches for all AD groups meeting search term, then loops through them all and collects names of all members.Also counts number of members
  Sends results to a custom object that could be exported to table, csv etc.
#>

# defines search term - use * as a wildcard
$SearchTerm = "*"

# creates list of groups meeting description
$Groups = Get-ADGroup -filter * | where {$_.name -like $SearchTerm}

# Loops through list of groups 
$Results = foreach ($Group in $Groups) {

   # defines variables     
   $Name = $Group.name
   $GroupMembers = Get-ADGroupmember $Group
   $Count = ($GroupMembers | Measure-Object).count

   # Sets 'name' of group member if group is empty by creating a custom object with a 'name' value of "-"
    If ($Count -lt 1) { $GroupMembers = [pscustomobject]@{ Name = "-" } }
  
       # Gets all group members of listed groups
       foreach ($GroupMember in $GroupMembers) {
        
        # defines variable
        $GroupMemberName = $GroupMember.name
        
        # creates a custom object containing data   
        [pscustomobject]@{

                GroupName = $Name
                MemberName = $GroupMemberName
                NumberOfMembers = $Count  

                }
            }
  } 

# outputs the result as a table 
$Results|format-table
