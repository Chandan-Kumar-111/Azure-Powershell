#Create WebApp
#variables
$appname="mysiteapp$(Get-Random)"
$res="myres"
$loc= "Southeast Asia"
$plan="appplan"
$giturl="https://github.com/Chandan-Kumar-111/AzureTest.git"
$gitproperty=@{repoUrl="$giturl";branch="master"; isManualIntegration="true";}
$dbserver="test$(Get-Random)"
$dbname="sampledb"
$dblogin="dbuser"
$dbpwd="user12345678"
$sqlcred= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $dblogin , (ConvertTo-SecureString -String $dbpwd -AsPlainText -Force)
$startIp=""
$endIp=""

#create Resource Group

New-AzResourceGroup -Name $res -Location $loc

#create Resource plan

New-AzAppServicePlan -Name $plan -Location $loc -Tier Basic -ResourceGroupName $res

#create web app

New-AzWebApp -Name $appname -Location $loc -ResourceGroupName $res -AppServicePlan $plan 

#git configuration

Set-AzResource -Properties $gitproperty -ResourceGroupName $res -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $appname/web -ApiVersion 2015-08-01 -Force

#create DB server

New-AzSqlServer -Servername $dbserver -Location $loc -ResourceGroupName $res -SqlAdministratorCredentials $sqlcred

#create DB

New-AzSqlDatabase -DatabaseName $dbname -ServerName $dbserver -ResourceGroupName $res

#Add Firewall

New-AzSqlServerFirewallRule -FirewallRuleName "clientip1" -StartIpAddress $startIp -EndIpAddress $endIp -ServerName $dbserver -ResourceGroupName $res

# Assign Connection String to Connection String 
Set-AzWebApp -ConnectionStrings @{ MyConnectionString = @{ Type="SQLAzure"; Value ="Server=tcp:$dbserver.database.windows.net;Database=MySampleDatabase;User ID=$Username@$ServerName;Password=$password;Trusted_Connection=False;Encrypt=True;" } } -Name $appname -ResourceGroupName $res
#value is ADO.net which is SQL authentication