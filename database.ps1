#create DB
#variables
$res="myres"
$loc= "Southeast Asia"
$dbserver="test$(Get-Random)"
$dbname="sampledb"
$dblogin="dbuser"
$dbpwd="user12345678"
$sqlcred= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $dblogin , (ConvertTo-SecureString -String $dbpwd -AsPlainText -Force)
$startIp=""
$endIp=""
#test git.----

#create DB server

New-AzSqlServer -Servername $dbserver -Location $loc -ResourceGroupName $res -SqlAdministratorCredentials $sqlcred

#create DB

New-AzSqlDatabase -DatabaseName $dbname -ServerName $dbserver -ResourceGroupName $res

#Add Firewall

New-AzSqlServerFirewallRule -FirewallRuleName "clientip1" -StartIpAddress $startIp -EndIpAddress $endIp -ServerName $dbserver -ResourceGroupName $res