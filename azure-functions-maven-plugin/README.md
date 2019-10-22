# Maven Plugin for Azure Functions
[![Maven Central](https://img.shields.io/maven-central/v/com.microsoft.azure/azure-functions-maven-plugin.svg)](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22com.microsoft.azure%22%20AND%20a%3A%22azure-functions-maven-plugin%22)

#### Table of Content
  - [Prerequisites](#prerequisites)
  - [Goals](#goals)
      - [azure-functions:package](#azure-functionspackage)
      - [azure-functions:add](#azure-functionsadd)
      - [azure-functions:run](#azure-functionsrun)
      - [azure-functions:deploy](#azure-functionsdeploy)
  - [Usage](#usage)
  - [Common Configuration](#common-configuration)
  - [Configurations](#configurations)
    - [Supported Regions](#supported-regions)
    - [Supported Pricing Tiers](#supported-pricing-tiers)
  - [How-To](#how-to)
    - [Generate the function archetype](#generate-the-function-archetype)
    - [Add new function to current project](#add-new-function-to-current-project)
    - [Generate `function.json` from current project](#generate-functionjson-from-current-project)
    - [Run Azure Functions locally](#run-azure-functions-locally)
    - [Deploy Azure Functions to Azure](#deploy-azure-functions-to-azure)
    - [Add Proxies Configuration to Your Azure Function](#add-proxies-configuration-to-your-azure-function)
  - [Common Questions](#common-questions)

## Prerequisites

Tool | Required Version
---|---
JDK | 1.8
Maven | 3.0 and above
[.Net Core SDK](https://www.microsoft.com/net/core) | Latest version
[Azure Functions Core Tools](https://www.npmjs.com/package/azure-functions-core-tools) | 2.0 and above
>Note: [See how to install Azure Functions Core Tools - 2.x](https://aka.ms/azfunc-install)

## Goals

#### `azure-functions:package`
- Scan the output directory (default is `${project.basedir}/target/classes`) and generating `function.json` for each function (method annotated with `FunctionName`) in the staging directory.
- Copy JAR files from the build directory (default is `${project.basedir}/target/`) to the staging directory.

> The default lifecycle phase for `azure-functions:package` is `package`. You can simply run `mvn package` to generate all the outputs you need to run/deploy your project.

> Default staging directory is `${project.basedir}/target/azure-functions/${function-app-name}/`

#### `azure-functions:add`
- Create a new Java function and add to the current project.
- You will be prompted to choose a template and enter parameters. Templates for below triggers are supported as of now:
    - HTTP Trigger
    - Azure Storage Blob Trigger
    - Azure Storage Queue Trigger
    - Timer Trigger
    - Event Grid Trigger
    - Event Hub Trigger
    - Cosmos DB Trigger
    - Service Bus Queue Trigger
    - Service Bus Topic Trigger

#### `azure-functions:run`
- Invoke Azure Functions Local Emulator to run all functions. Default working directory is the staging directory.

#### `azure-functions:deploy` 
- Deploy the staging directory to target Azure Functions.
- If target Azure Functions does not exist already, it will be created.
 

## Usage

To use the Maven Plugin for Azure Functions in your Maven Java app, add the following snippet to your `pom.xml` file:

```xml
<project>
  ...
  <build>
    ...
    <plugins>
      ...
      <plugin>
        <groupId>com.microsoft.azure</groupId>
          <artifactId>azure-functions-maven-plugin</artifactId>
          <version>1.3.2</version>
          <configuration>
            ...
          </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

Read [How-To](#how-to) section to learn detailed usages.

## Common Configuration

This Maven plugin supports common configurations of all Maven Plugins for Azure.
Detailed documentation of common configurations is at [here](../docs/common-configuration.md).

## Configurations

This Maven Plugin supports the following configuration properties:

Property | Required | Description
---|---|---
`<resourceGroup>` | true | Specifies the Azure Resource Group for your Azure Functions.
`<appName>` | true | Specifies the name of your Azure Functions.
`<region>`* | false | Specifies the region where your Azure Functions will be hosted; default value is **westus**. All valid regions are at [Supported Regions](#supported-regions) section.
`<pricingTier>`* | false | Specifies the pricing tier for your Azure Functions; default value is **Consumption**. All valid pricing tiers are at [Supported Pricing Tiers](#supported-pricing-tiers) section.
`<appServicePlanResourceGroup>` | false | Specifies the resource group of the existing App Service Plan when you do not want to create a new one. If this setting is not specified, the plugin will use the value defined in `<resourceGroup>`.
`<appServicePlanName>` | false | Specifies the name of the existing App Service Plan when you do not want to create a new one.
`<appSettings>` | false | Specifies the application settings for your Azure Functions, which are defined in name-value pairs like following example:<br>`<property>`<br>&nbsp;&nbsp;&nbsp;&nbsp;`<name>xxxx</name>`<br>&nbsp;&nbsp;&nbsp;&nbsp;`<value>xxxx</value>`<br>`</property>`
`<deploymentType>` | false | Specifies the deployment approach you want to use.<br>The default value is **`zip`**. When `<deploymentType>` is **zip** and **WEBSITE_RUN_FROM_PACKAGE** in appSettings values **1**, the function will be deployed and run from package, you may visit [here](https://docs.microsoft.com/en-us/azure/azure-functions/run-functions-from-deployment-package) for more information.
`<httpProxyHost>` | false | Specifies an optional HTTP proxy to connect to Azure through.
`<httpProxyPort>` | false | Specifies an optional HTTP proxy port to connect to Azure through <br>The default value is **80**.
`<localDebugConfig>` | false | The config string of debug options, you may visit [here](https://docs.oracle.com/javase/7/docs/technotes/guides/jpda/conninv.html) for more information. The default value is `transport=dt_socket,server=y,suspend=n,address=5005`;
>*: This setting will be used to create a new Azure Functions if specified Azure Functions does not exist; if target Azure Functions already exists, this setting will be ignored.
### Supported Regions
All valid regions are listed as below. Read more at [Azure Region Availability](https://azure.microsoft.com/en-us/regions/services/).
- `westus`
- `westus2`
- `eastus`
- `eastus2`
- `northcentralus`
- `southcentralus`
- `westcentralus`
- `canadacentral`
- `canadaeast`
- `brazilsouth`
- `northeurope`
- `westeurope`
- `uksouth`
- `eastasia`
- `southeastasia`
- `japaneast`
- `japanwest`
- `australiaeast`
- `australiasoutheast`
- `centralindia`
- `southindia`

### Supported Pricing Tiers
Consumption plan is the default if you don't specify anything for your Azure Functions.
You can also run Functions within your App Service Plan. All valid App Service plan pricing tiers are listed as below.
Read more at [Azure App Service Plan Pricing](https://azure.microsoft.com/en-us/pricing/details/app-service/).
- `F1`
- `D1`
- `B1`
- `B2`
- `B3`
- `S1`
- `S2`
- `S3`
- `P1V2`
- `P2V2`
- `P3V2`

## How-To

### Generate the function archetype
Run below command to generate the function archetype:

```cmd
mvn archetype:generate -DarchetypeGroupId=com.microsoft.azure -DarchetypeArtifactId=azure-functions-archetype
```

### Add new function to current project
Run below command to create a new function:
- In package `com.your.package`
- Named `NewFunction`
- Bound to `HttpTrigger`

```cmd
mvn azure-functions:add -Dfunctions.package=com.your.package -Dfunctions.name=NewFunction -Dfunctions.template=HttpTrigger
```

You don't have to provide all the properties on the command line. Missing properties will be prompted for input during the execution of the goal.

### Generate `function.json` from current project

Follow below instructions, you don't need to handwrite `function.json` anymore.
1. Use annotations from package `com.microsoft.azure:azure-functions-java-library` to decorate your functions. 
2. Run `mvn clean package`; then `function.json` files will be automatically generated for all functions in your project.

### Run Azure Functions locally

With the help of goal `azure-functions:run`, you can run your Azure Functions in current project locally with below command:

```cmd
mvn azure-functions:run
```

If you want to start the function host in debug mode, please add `-DenableDebug` as the argument. The function host use TCP-Socket Transport and listen on 5005 port by default, you may change the config string in configuration properties.
```cmd
mvn azure-functions:run -DenableDebug
```

>Note:
>Before you can run Azure Functions locally, install [.Net Core SDK](https://www.microsoft.com/net/core) and 
[Azure Functions Core Tools](https://www.npmjs.com/package/azure-functions-core-tools) first.

### Deploy Azure Functions to Azure

Directly deploy to target Azure Functions by running `mvn azure-functions:deploy`.

Supported deployment methods are listed as below. The default value is **ZIP**.
- ZIP
- ~~~MSDeploy~~~ (deprecated)
- ~~~FTP~~~ (deprecated)

### Configuring Credentials for Azure Deployment
#### Using AZ login
When deploying from local development environment, you can login interactively using your Azure AD login credentials. You can set the default subscription to deploy the resources using appropriate az command or you can specify the SubscriptionId in the Maven plug-in configuration for Azure Functions (shown below) 

```bash
az login
``` 
#### Using Azure Service Principal
You can also use Azure Service Principal (SP) with sifficient RBAC permissons to authenticate to Azure, create Azure resources and deploy the Function app.  Please refer to Azure documentation for more details on how to create an Azure Service Principal (SP) and assign RBAC permissions to it. Once the SP is created, make note of Client_Id (also referred to as Application_id), Client_Secret, and Tenant_Id information for the Service Pricipal

Add the following server configuration to Maven settings file.  In the POM.xml, when configuring the Maven plugin for Azure Functions (shown below), use the server/Id (azure-auth in the example below) from Maven settings file to configure the serverId value in the authentication element plugin configuration element

```XML
<server> 
    <id>azure-auth</id> 
      <configuration> 
        <tenant>Tenant_Id</tenant> 
        <client>Client_Id</client> 
        <key>Client_Secret</key> 
        <environment>AZURE</environment> 
      </configuration> 
</server> 
```
```XML
<plugin> 
    <groupId>com.microsoft.azure</groupId> 
    <artifactId>azure-functions-maven-plugin</artifactId> 
    <configuration> 
        <authentication> 
            <serverId>azure-auth</serverId> 
        </authentication> 
        <resourceGroup>${azure.functions.resourcegroup}</resourceGroup> 
        <appName>${azure.functions.appname}</appName> 
        <region>${azure.functions.appregion}</region> 
        <subscriptionId>${azure.functions.subscriptionid}</subscriptionId> 
        <appServicePlanName>${azure.functions.appserviceplanname}</appServicePlanName> 
        <appSettings> 
            <!-- Run Azure Function from package file by default --> 
            <property> 
                <name>WEBSITE_RUN_FROM_PACKAGE</name> 
                <value>1</value> 
            </property> 
            <property> 
                <name>FUNCTIONS_EXTENSION_VERSION</name> 
                <value>~2</value> 
            </property> 
            <property> 
                <name>KEY</name> 
                <value>VALUE</value> 
            </property> 
        </appSettings> 
    </configuration> 
    <executions> 
        <execution> 
            <id>package-functions</id> 
            <goals> 
                <goal>package</goal> 
            </goals> 
        </execution> 
    </executions> 
</plugin> 
```


### Add Proxies Configuration to Your Azure Function

[Azure Functions proxies](https://docs.microsoft.com/en-us/azure/azure-functions/functions-proxies) can be used for things like URL rewriting. To include a `proxies.json` file in your deployment you need to add it to the `maven-resources-plugin` configuration in `pom.xml` alongside `host.json` and `local.settings.json`.

For example, if you had a function bound to the path `api/index` which you wanted to also expose at the root URL of your Functions app you can do that with a `proxies.json` like this:

```json
{
  "$schema": "http://json.schemastore.org/proxies",
  "proxies": {
    "IndexProxy": {
      "matchCondition": {
        "route": "/"
      },
      "backendUri": "https://%WEBSITE_HOSTNAME%/api/index"
    }
  }
}
```

## Common Questions
**Q: Can I upload other static content, e.g. HTML files, as part of the function deployment?**

**A:** You can achieve this by adding configurations for the `maven-resources-plugin`. For example:
```xml
<plugin>
  <artifactId>maven-resources-plugin</artifactId>
  <executions>
    <execution>
      <id>copy-resources</id>
      <phase>package</phase>
      <goals>
        <goal>copy-resources</goal>
      </goals>
      <configuration>
        <overwrite>true</overwrite>
        <outputDirectory>${stagingDirectory}</outputDirectory>
        <resources>         
          ...         
          <!-- Your static resources -->
          <resource>
            <directory>${project.basedir}/src/main/resources</directory>
            <includes>
              <include>www/**</include>
            </includes>
          </resource>
        </resources>
      </configuration>
    </execution>
    ...
  </executions>
</plugin>
``` 
