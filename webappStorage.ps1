#Create WebApp and storage
#variables
$appname="mysiteapp$(Get-Random)"
$res="myres"
$loc= "Southeast Asia"
$plan="appplan"
$giturl="https://github.com/Chandan-Kumar-111/AzureTest.git"
$gitproperty=@{repoUrl="$giturl";branch="master"; isManualIntegration="true";}
$account="appstore$(Get-Random)"

#create Resource Group

New-AzResourceGroup -Name $res -Location $loc

#create Resource plan

New-AzAppServicePlan -Name $plan -Location $loc -Tier Basic -ResourceGroupName $res

#create web app

New-AzWebApp -Name $appname -Location $loc -ResourceGroupName $res -AppServicePlan $plan 

#git configuration

Set-AzResource -Properties $gitproperty -ResourceGroupName $res -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $appname/web -ApiVersion 2015-08-01 -Force

#create storage account
New-AzStorageAccount -Name $account -ResourceGroupName $res -Location $loc -SkuName Standard_LRS

#get account key
$accountkey=(Get-AzStorageAccountKey -ResourceGroupName $res -Name $account).Value[0]

# Assign Connection String to App Setting 
Set-AzWebApp -ConnectionStrings @{ MyStorageConnStr = @{ Type="Custom"; Value="DefaultEndpointsProtocol=https;AccountName=$account;AccountKey=$accountkey;" } } -Name $appname -ResourceGroupName $res