#Create WebApp
#variables
$appname="mysiteapp$(Get-Random)"
$res="myres"
$loc= "Southeast Asia"
$plan="appplan"

#create Resource Group

New-AzResourceGroup -Name $res -Location $loc

#create Resource plan

New-AzAppServicePlan -Name $plan -Location $loc -Tier Basic -ResourceGroupName $res

#create web app

New-AzWebApp -Name $appname -Location $loc -ResourceGroupName $res -AppServicePlan $plan 

#git configuration

Set-AzResource -Properties gitproperty -ResourceGroupName $res -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $appname/web -ApiVersion 2015-08-01 -Force

