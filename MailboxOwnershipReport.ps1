<#
.SYNOPSIS
 If you add Mailbox ownership information to the 'Info' attribute in AD, this can then be viewed in the Notes section of mailbox propererties in Outlool
 This report searches for this information and outputs to a table.
.DESCRIPTION
The formating of the ownership information must be as below: 
Owner - Tom Jones
Additional Approvers - Brian Jones, Bob Jones

#>




$MailboxesOU = INSERT OU HERE

# gets all mailboxes in the OU and pipes into a foreach loop
Get-Aduser -Filter * -SearchBase $MailboxesOU -Properties department, info, emailaddress | sort department | foreach {


    If (($_.info -like "Owner*") -and ($_.info -like "*Additional*")) { 

       # splits Notes string into two lines and formats the string
        $Notes = $_.info -split "`r`n"
        $Owner = $Notes[0].Replace('Owner - ','')
        $Owner = $Owner.TrimEnd()
        $Approver = $Notes[1].Replace('Additional Approvers - ','')
    

    } elseif  (($_.info -like "Owner*") -and ($_.info -notlike "*Additional*")) { 
  
        $Owner = $_.info.replace('Owner - ','')
        $Owner = $Owner.TrimEnd()
        $Approver = '-'

    } else {  $Owner = '-' ; $ActiveInAD = '-' ; $Approver = '-'  } 

    If ($Owner -notlike '-') {
        
        # searches for the owner in AD
        $OwnerName = $Owner.split(' ')
        $FirstName = $OwnerName[0]
        $LastName = $OwnerName[1]
        $ADSearch = Get-aduser -Filter ( { (givenname -like $FirstName) -and (surname -like $LastName) } )
        if ($ADsearch) { $ActiveInAD = "True" } else {$ActiveInAD = "Not Found"} 
    }

        #creates a custom object to export to a table, csv etc 
        [pscustomobject]@{

            Name = $_.name 
            Emailaddress = $_.emailaddress
            Department = $_.department
            Owner = $Owner
            OwnerActiveInAD = $ActiveInAD
            Approvers = $Approver
        
            }


 }| format-table 
