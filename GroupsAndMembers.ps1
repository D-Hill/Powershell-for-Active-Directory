<#
.SYNOPSIS
  Script to show all members of AD groups meeting a specified search term
.DESCRIPTION
  Searches for all AD groups meeting search term, then loops through them all and collects names of all members.Also counts number of members
  Sends results to a custom object that could be exported to table, csv etc.
#>

# defines search term - use * as a wildcard
$SearchTerm = "ABC*"

# creates list of groups meeting description
$Groups = Get-ADGroup -filter 'name -like $SearchTerm' -Properties description

# Loops through list of groups 
$Results = foreach ($Group in $Groups) {

   # defines variables     
  
   $GroupMembers = Get-ADGroupmember $Group
   $Count = ($GroupMembers | Measure-Object).count

   # Sets group detail if group is empty
    If ($Count -eq 0) { 
    
                        [pscustomobject]@{ 
    
 
                                        GroupName = $Group.name
                                        GroupDescription = $Group.description
                                        NumberOfMembers = $Count
                                        MemberName = "-"
                                        MemberID = "-"                                        
                                        MemberDept = "-"
                                        MemberTitle = "-"
    
                                        } 
    
    }
    
    
    else {     
    
            foreach ($GroupMember in $GroupMembers) {
        
                                                        $MemberAd = $null
                                                        $MemberAD = get-aduser $GroupMember.sid -Properties title, department,manager

                                                        $Manager = $null
                                                        If ($MemberAd.manager)  {   $Manager = (get-aduser $MemberAd.manager -ErrorAction SilentlyContinue).name }

        
                                                         # creates a custom object containing data   
                                                         [pscustomobject]@{

                                                                            GroupName = $Group.name
                                                                            GroupDescription = $Group.description
                                                                            NumberOfMembers = $Count
                                                                            MemberName = $GroupMember.name
                                                                            MemberID = $MemberAd.samaccountname
                                                                            MemberDept = $MemberAD.Department
                                                                            MemberTitle = $MemberAD.title
                                                                            Manager = $Manager

                                                                                        }
            
                                                     }                                                           
     
            }
                    
  } 

# outputs the result as a table 
$Results|format-table
