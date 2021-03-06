#This script will look in the default Computer Container (or any OU you specify on line 4) for computers only (not servers) and resolve their DNS name to IP
#and move the computer to an OU depending on the IP its at. .2 computers go to a sites computers OU and .1 computers go to another OU

$Computers = Get-ADObject -SearchBase "CN=Computers,DC=microsoft,DC=local" -LDAPFilter '(objectClass=Computer)' | Select-Object -Expand Name
ForEach ($Computer in $Computers)
{
$IPAddress = (Resolve-DnsName $Computer).IPAddress
Write-Host "$Computer is at $IPAddress" -ForegroundColor Cyan
If ($IPAddress -like "10.1.2.*")
    {
    Write-Host "Moving $Computer to Main Building OU..." -ForegroundColor Yellow
    Get-ADComputer $Computer | Move-ADObject -TargetPath "ou=Main Building,ou=Computers,dc=microsoft,dc=local"
    }
ElseIf ($IPAddress -like "10.1.1.*")
    {
    Write-Host "Moving $Computer to Second Building OU..." -ForegroundColor Yellow
    Get-ADComputer $Computer | Move-ADObject -TargetPath "ou=Second Building,ou=Computers,dc=microsoft,dc=local"
    }
Else
    {
    Write-Host "Not able to move $Computer" -ForegroundColor Red
    }
}


