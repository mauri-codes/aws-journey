PRE_EXPRESSION='{":pk":{"S":"user_'
POST_EXPRESSION='"},":sk":{"S":"account"}}'
ACTION=DEPLOY2
export USER_STATE_BUCKET=aws-journey-infra
export USER_STATE_TABLE=aws-journey-user-state
export CURRENT_DATE=$(date '+%Y-%m-%d_%H:%M:%S')
export USER_ID=test1
export LAB_ID=S3Website
# aws dynamodb put-item \
#     --table-name $APP_TABLE \
#     --item "{\"pk\":{\"S\":\"user_$USER_ID#deployment_$LAB_ID\"},\"sk\":{\"S\":\"run_$RUN_ID\"},\"state\":{\"S\":\"STARTED\"}}"

QUERY=`aws dynamodb query \
  --table-name $APP_TABLE \
  --key-condition-expression "pk = :pk and begins_with(sk, :sk)" \
  --expression-attribute-values $PRE_EXPRESSION$USER_ID$POST_EXPRESSION`


COUNT=`echo $QUERY | jq '.Count'`

echo $COUNT
echo $QUERY

if [ "$COUNT" -eq 0 ]; then
  echo "ERROR COUNT 0"
  exit 1
else
  ACCOUNT1_ROLE=`echo $QUERY | jq '.Items[0].assume_role.S'`
  ACCOUNT1_REGION_A=`echo $QUERY | jq '.Items[0].region.S'`
  ACCOUNT1_REGION_B=`echo $QUERY | jq '.Items[0].secondary_region.S'`
  if [ "$COUNT" -eq 1 ]; then
    ACCOUNT2_ROLE=$ACCOUNT1_ROLE
    ACCOUNT2_REGION_A=$ACCOUNT1_REGION_A
    ACCOUNT2_REGION_B=$ACCOUNT1_REGION_B
  else
    ACCOUNT2_ROLE=`echo $QUERY | jq '.Items[1].assume_role.S'`
    ACCOUNT2_REGION_A=`echo $QUERY | jq '.Items[1].region.S'`
    ACCOUNT2_REGION_B=`echo $QUERY | jq '.Items[1].secondary_region.S'`
  fi
fi

export ACCOUNT_1_ROLE=`echo $ACCOUNT1_ROLE | tr -d '"'`
export ACCOUNT_1_REGION_A=`echo $ACCOUNT1_REGION_A | tr -d '"'`
export ACCOUNT_1_REGION_B=`echo $ACCOUNT1_REGION_B | tr -d '"'`
export ACCOUNT_2_ROLE=`echo $ACCOUNT2_ROLE | tr -d '"'`
export ACCOUNT_2_REGION_A=`echo $ACCOUNT2_REGION_A | tr -d '"'`
export ACCOUNT_2_REGION_B=`echo $ACCOUNT2_REGION_B | tr -d '"'`

echo $ACCOUNT1_ROLE
echo $ACCOUNT1_REGION_A
echo $ACCOUNT1_REGION_B
echo $ACCOUNT2_ROLE
echo $ACCOUNT2_REGION_A
echo $ACCOUNT2_REGION_B

if [ "$ACTION" == "DEPLOY" ]; then
  chars=ABCDEFGHIJKLMNOPQRSTUVWXYZ
  numbers=1234567890
  RAN_STRING1=""
  RAN_STRING2=""
  RAN_NUMBER=""
  for i in {1..2} ; do
      RAN_STRING1+=`echo "${chars:RANDOM%${#chars}:1}"`
      RAN_STRING2+=`echo "${chars:RANDOM%${#chars}:1}"`
      RAN_NUMBER+=`echo "${numbers:RANDOM%${#numbers}:1}"`
  done
  export RUN_ID=$RAN_STRING1-$RAN_NUMBER-$RAN_STRING2

  cd $LAB_ID/iac

  terragrunt init

  terragrunt apply -auto-approve


  else
  export RUN_ID=HW-96-XE
  terragrunt init
  terragrunt destroy -auto-approve

fi

echo DONE