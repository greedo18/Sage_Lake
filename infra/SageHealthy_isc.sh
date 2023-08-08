####################################################################################################################################################
# Usage:
# $ sh ~/infra/SageHealthy_isc.sh IACRESOURCEGROUPNAME=SageHealthy_iac RESOURCEGROUPNAME=SageHealthy_prod LOCATION=eastus \
#   TEMPLATE_FILE_PATH=<HOME_DIR>/infra \
#   PARAMETERS_FILE_PATH=<HOME_DIR>/infra/parameters
####################################################################################################################################################


####################################################################################################################################################
# Get arguments

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            IACRESOURCEGROUPNAME)              IACRESOURCEGROUPNAME=${VALUE} ;;
            RESOURCEGROUPNAME)                 RESOURCEGROUPNAME=${VALUE} ;;
            LOCATION)                          LOCATION=${VALUE} ;;
            TEMPLATE_FILE_PATH)                TEMPLATE_FILE_PATH=${VALUE} ;;
			PARAMETERS_FILE_PATH)              PARAMETERS_FILE_PATH=${VALUE} ;;
            *)
    esac


done
####################################################################################################################################################

####################################################################################################################################################
echo "Start creation of Resource group: $RESOURCEGROUPNAME"

az group create --name $RESOURCEGROUPNAME --location $LOCATION 

echo "End creation of Resource group: $RESOURCEGROUPNAME"
####################################################################################################################################################


####################################################################################################################################################
echo "Start creation of Lakehouse_Storage_Account"

TEMPLATE_FILE=$TEMPLATE_FILE_PATH/storage_accounts/storage_accounts.json
PARAMETERS_FILE=$PARAMETERS_FILE_PATH/storage_accounts_parameters.json
az deployment group create --name Lakehouse_Storage_Account --resource-group $RESOURCEGROUPNAME --template-file $TEMPLATE_FILE --parameters $PARAMETERS_FILE

echo "End creation of Lakehouse_Storage_Account"
####################################################################################################################################################       


####################################################################################################################################################
echo "Start creation of Lakehouse_Databricks"

TEMPLATE_FILE=$TEMPLATE_FILE_PATH/databricks/databricks.json
PARAMETERS_FILE=$PARAMETERS_FILE_PATH/databricks_parameters.json
az deployment group create --name Lakehouse_Databricks --resource-group $RESOURCEGROUPNAME --template-file $TEMPLATE_FILE --parameters $PARAMETERS_FILE

echo "End creation of Lakehouse_Databricks"
####################################################################################################################################################    


####################################################################################################################################################
echo "Start creation of Lakehouse_DataFactory"

TEMPLATE_FILE=$TEMPLATE_FILE_PATH/data_factory/data_factory.json
PARAMETERS_FILE=$PARAMETERS_FILE_PATH/data_factory_parameters.json
az deployment group create --name Lakehouse_DataFactory --resource-group $RESOURCEGROUPNAME --template-file $TEMPLATE_FILE --parameters $PARAMETERS_FILE

echo "End creation of Lakehouse_DataFactory"
####################################################################################################################################################

####################################################################################################################################################
echo "Start creation of Lakehouse_Synapse"

TEMPLATE_FILE=$TEMPLATE_FILE_PATH/synapse/synapse.json
PARAMETERS_FILE=$PARAMETERS_FILE_PATH/synapse_parameters.json
az deployment group create --name Lakehouse_Synapse --resource-group $RESOURCEGROUPNAME --template-file $TEMPLATE_FILE --parameters $PARAMETERS_FILE

echo "End creation of Lakehouse_Synapse"
####################################################################################################################################################    


