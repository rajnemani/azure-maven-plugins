## Install Azure CLI
az extension add -y --source https://github.com/VSChina/azure-cli-extensions/releases/download/0.4/spring_cloud-0.4.0-py2.py3-none-any.whl
## Prepare Spring Cluster
$cluster = "spring-cloud-ci-$Env:BuildId";
az group create --name $cluster -l eastus
az spring-cloud create -g $cluster -n $cluster
az spring-cloud config-server git set --resource-group $cluster --name $cluster --uri https://github.com/xscript/piggymetrics-config.git

## Clone
git clone https://github.com/Azure-Samples/piggymetrics.git
cd piggymetrics
mvn clean package -DskipTests
"N`r`nY"| mvn -f "./account-service/pom.xml" com.microsoft.azure:azure-spring-cloud-maven-plugin:config -DclusterName="hanli-cluster-test" -DappName="account-service"
"N`r`nY"| mvn -f "./auth-service/pom.xml" com.microsoft.azure:azure-spring-cloud-maven-plugin:config -DclusterName="hanli-cluster-test" -DappName="auth-service"
"Y`r`nY"| mvn -f "./gateway/pom.xml" com.microsoft.azure:azure-spring-cloud-maven-plugin:config -DclusterName="hanli-cluster-test" -DappName="gateway"
mvn com.microsoft.azure:azure-spring-cloud-maven-plugin:deploy



## Clean resources
az spring-cloud delete -g $cluster -n $cluster