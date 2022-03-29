# PaohAzureInfra

# Introduction 
Bicep templates for deploying Azure resources needed for deploying Palveluohjain's Azure resources.

# Getting Started
This repository contains bicep templates for deploying Palveluohjaaja resources to Azure.

Bicep templates are configurations that define the Azure resources that the bots infrastructure needs. The purpose of the templates is to make setting up the environment easy so that you do not have to set it up manually with cumbersome detailed instructions and settings. The environment is deployed using templates in a defined order, starting from the base resurces and higher level dependent resources are deployed on these.

Resources are divided into several different categories:

## Resources_intra
This includes common resources that are shared across different environments. If you want to create both test and production environments to Azure, then create only one resource from this group and they serve all the environments. Do not create your own resource for each environment in this group. This requires a resource group created as a basis for shared resources.

## Resources
The resources here are similar in shape regardless of the environment, but unlike those in the intra-group, one resource of this group must be created for each environment. These require a resource group created for that environment as a basis.

## Resources_test and Resources_prod
The resources here are created in the same way as the ones of previous group,  one for each environment. The difference is that the form of these resources depends on the type of the environment they belong to, and therefore the test and production have their own slightly different templates. Use Resources_test templates for the test environment and Resources_prod templates for the production environment. Create only one resource for each environment. This requires the same environment-specific resource group created in the previous one.

## Using templates
The templates are in an easy-to-read `.bicep` format. To use them, they must be converted to `.json` format as ARM templates using the `bicep-cli` tool. (https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli).
With these modified templates, resources can be created to an existing resource group. For example, from the Azure portal through the Deploy Custom Template interface, these generated ARM templates can be used to access Azure resources (https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-the-portal).

When using templates, when deploying each template, make sure that the variables `subscriptionId`, `resourceGroupName`, `intraResourceGroupName`, and `environment` are set correctly. The name of the environment should preferably be short 1-6 lowercase, e.g. test or produce. This is because Azure does not allow long names for all resources. Other variables are derivatives so do not set these yourself.

## Deploying order:
At the beginning, there must be a common resource group and one resource group for each environment. If both test and production are set up, then a separate group for each, a total of 3.

### Translator
Add a Translator resource to the intra resource group using the `Translator.bicep` template.

### Virtual network
Add a virtual network to the environment-specific resource group with the `VN.bicep` template.

### Cosmos database
Add the Cosmos database server to the environment-specific resource group using the `DB.bicep` template.

### Database connection to the virtual network
Add a private endpoint for Cosmos database server into virtual network to the environment-specific resource group using the `DBPEP.bicep` template. This template requires that the previous virtual network and database already exist in the group. The virtual network resources then gain access to the database.

### Container Registry
Add to the environment-specific resource group using the Azure Container Registry `ContainerRegistry.bicep` template. This is used as a register for Docker containers exported to the environment.

### Strorage Account
Add a Storage Account to the environment-specific resource group with the `StorageAccount_test.bicep` or `StorageAccount_prod.bicep` template, depending on your environment.

### Static Web App
Add to the environment-specific resource group with the `StaticWebApp_test.bicep` or `StaticWebApp_prod.bicep` template, depending on the environment.

### AKS
Add Azure Kubernetes Services to the environment-specific resource group using the `AKS_test.bicep` or `AKS_prod.bicep` template, depending on your environment. AKS is the core of the environment and contains most of the functionalities. 



