#!/bin/bash

# Function to display usage instructions
function display_usage {
    echo "Usage: $0 IACRESOURCEGROUPNAME=<IACResourceGroupName> RESOURCEGROUPNAME=<ResourceGroupName> LOCATION=<Location> TEMPLATE_FILE_PATH=<TemplateFilePath> PARAMETERS_FILE_PATH=<ParametersFilePath>"
    exit 1
}

# Validate the number of arguments
if [ $# -ne 5 ]; then
    display_usage
fi

# Initialize variables with default values
IACRESOURCEGROUPNAME=""
RESOURCEGROUPNAME=""
LOCATION=""
TEMPLATE_FILE_PATH=""
PARAMETERS_FILE_PATH=""

# Get arguments
for ARGUMENT in "$@"; do
    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
    VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)
    
    case "$KEY" in
        IACRESOURCEGROUPNAME)  IACRESOURCEGROUPNAME="$VALUE" ;;
        RESOURCEGROUPNAME)     RESOURCEGROUPNAME="$VALUE" ;;
        LOCATION)              LOCATION="$VALUE" ;;
        TEMPLATE_FILE_PATH)    TEMPLATE_FILE_PATH="$VALUE" ;;
        PARAMETERS_FILE_PATH)  PARAMETERS_FILE_PATH="$VALUE" ;;
        *) display_usage ;;
    esac
done

# Validate required arguments
if [ -z "$IACRESOURCEGROUPNAME" ] || [ -z "$RESOURCEGROUPNAME" ] || [ -z "$LOCATION" ] || [ -z "$TEMPLATE_FILE_PATH" ] || [ -z "$PARAMETERS_FILE_PATH" ]; then
    echo "All arguments are required!"
    display_usage
fi

# Function to create a resource group
function create_resource_group {
    echo "Start creation of Resource group: $RESOURCEGROUPNAME"
    az group create --name "$RESOURCEGROUPNAME" --location "$LOCATION"
    echo "End creation of Resource group: $RESOURCEGROUPNAME"
}

# Function to deploy resources
function deploy_resources {
    local category=$1
    local template_file="$TEMPLATE_FILE_PATH/$category/$category.json"
    local parameters_file="$PARAMETERS_FILE_PATH/${category}_parameters.json"

    echo "Start creation of $category"
    az deployment group create --name "Lakehouse_$category" --resource-group "$RESOURCEGROUPNAME" --template-file "$template_file" --parameters "$parameters_file"
    echo "End creation of $category"
}

# Main script flow
create_resource_group

# Deploy individual resources
deploy_resources "Storage_Account"
deploy_resources "Databricks"
deploy_resources "DataFactory"
deploy_resources "Synapse"
