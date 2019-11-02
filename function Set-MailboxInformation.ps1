
# this function can be used to enter ownership/approval information into the Notes section of a mailbox in AD. 
# it can also add to Description and Department fields



function Set-MailboxInformation {


    param(

    [parameter(Mandatory=$true)][String]$MailboxName,
    [String]$Owner,
    [string]$Approver1,
    [string]$Approver2,
    [string]$Approver3,
    [string]$Department,
    [string]$Description


    )

$Mailbox = get-aduser -Identity $MailboxName -Properties info 

$NewLine = "`r`n"
$Owner = "Owner - $Owner"

if ( $Approver1 ) {$Approver = "Additional Approvers - $Approver1"} 
if ( $Approver2 ) {$Approver2 =   ', ' + $Approver2 }
if ( $Approver3 ) {$Approver3 = ', ' + $Approver3 }


$Notes = $Owner + $NewLine + $Approver +  $Approver2 + $Approver3

set-aduser $MailboxName -replace @{info = "$Notes" }
if ( $Department ) { set-aduser $MailboxName -Department $Department }
if ( $Description ) { set-aduser $MailboxName -Description $Description }

}
