$MAX_RETRY = 3
$cluster = "spring-cloud-ci-$Env:BuildId";
$resourceGroup = "spring-cloud-ci-$Env:BuildId-rg";

Function ValidateApp($resourceGroup, $cluster, $app) {
    $appStatus = $null
    for ($i = 0; $i -lt $MAX_RETRY; $i++) {
        $appStatus = az spring-cloud app show --resource-group $resourceGroup -s $cluster --name auth-service | ConvertFrom-Json
        $deploymentStatus = $appStatus.properties.activeDeployment.properties.status -eq "Running"
        $instanceStatus = ($appStatus.properties.activeDeployment.properties.instances | Where-Object { ($_.discoveryStatus -ne "UP") -or ($_.status -ne "Running") } | measure).Count -le 0
        if ($deploymentStatus -and $instanceStatus) {
            return
        }
    }
    throw $appStatus | ConvertTo-Json
}

Function ValidatePublicAccess($url) {
    $response = $null
    for ($i = 0; $i -lt $MAX_RETRY; $i++) {
        $request = [System.Net.WebRequest]::Create($url)
        $response = $request.GetResponse()
        $response.Close();
        $status = [int]$response.StatusCode
        if ($status -eq 200) {
            return
        }
    }
    throw $response | ConvertTo-Json
}

## Auth
az login --service-principal --tenant $Env:TENANT_ID --username $Env:CLIENT_ID --password $Env:KEY
## Install Azure CLI
az extension add -y --source https://github.com/VSChina/azure-cli-extensions/releases/download/0.4/spring_cloud-0.4.0-py2.py3-none-any.whl
## Prepare Spring Cluster
az group create --name $resourceGroup -l eastus
az spring-cloud create -g $resourceGroup -n $cluster
az spring-cloud config-server git set --resource-group $resourceGroup --name $cluster --uri https://github.com/xscript/piggymetrics-config.git

## Deploy Piggy Metrics
git clone https://github.com/Azure-Samples/piggymetrics.git
cd piggymetrics
mvn clean package -DskipTests
"N`r`nY" | mvn -f "./account-service/pom.xml" com.microsoft.azure:azure-spring-cloud-maven-plugin:config -DclusterName=$cluster -DappName="account-service"
"N`r`nY" | mvn -f "./auth-service/pom.xml" com.microsoft.azure:azure-spring-cloud-maven-plugin:config -DclusterName=$cluster -DappName="auth-service"
"Y`r`nY" | mvn -f "./gateway/pom.xml" com.microsoft.azure:azure-spring-cloud-maven-plugin:config -DclusterName=$cluster -DappName="gateway"
mvn com.microsoft.azure:azure-spring-cloud-maven-plugin:deploy

## Validate Deployment Status
ValidateApp $resourceGroup $cluster "account-service"
ValidateApp $resourceGroup $cluster "auth-service"
ValidateApp $resourceGroup $cluster "gateway"

## Validate Public Access
$url = $gatewayStatus.properties.url
ValidatePublicAccess($url)

## Clean resources
az spring-cloud delete -g $resourceGroup -n $cluster