#!/bin/bash
# Passed validation in Cloud Shell on 2/11/2022

# Create an Azure Database for MySQL - Flexible Server Burstable B1ms instance
# and configure Public Access connectivity method

# Set up variables
let "randomIdentifier=$RANDOM*$RANDOM"
location="East US"
resourceGroup="msdocs-mysql-rg-$randomIdentifier"
tags="create-connect-burstable-server-public-access-mysql"
server="msdocs-mysql-server-$randomIdentifier"
login="azureuser"
password="Pa$$w0rD-$randomIdentifier"
ipAddress="None"
# Specifying an IP address of 0.0.0.0 allows public access from any resources
# deployed within Azure to access your server. Setting it to "None" sets the server 
# in public access mode but does not create a firewall rule.
# For your public IP address, https://whatismyipaddress.com

echo "Using resource group $resourceGroup with login: $login, password: $password..."

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" --tag $tag

# Create a MySQL Flexible server in the resource group
echo "Creating $server"
az mysql flexible-server create --name $server --resource-group $resourceGroup --location "$location" --admin-user $login --admin-password $password --public-access $ipAddress

# Optional: Add firewall rule to connect from all Azure services
# To limit to a specific IP address or address range, change start-ip-address and end-ip-address
echo "Adding firewall for IP address range"
az mysql flexible-server firewall-rule create --name $server --resource-group $resourceGroup --rule-name AllowAzureIPs --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# Connect to server in interactive mode
az mysql flexible-server connect --name $server --admin-user $login --admin-password $password --interactive

# echo "Deleting all resources"
# az group delete --name $resourceGroup -y
