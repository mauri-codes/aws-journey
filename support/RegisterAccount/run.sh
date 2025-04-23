# ./run.sh $JN_ACCOUNT $ACCOUT_NAME $REGION1 $REGION2 $ACCESS_TOKEN $ID_TOKEN
JN_ACCOUNT_ID=$1
ENV_NAME=$2
REGION1=$3
REGION2=$4
ACCESS_TOKEN=$5
ID_TOKEN=$6
LOCAL_ACCOUNT_ID=`aws sts get-caller-identity --query 'Account' --output text`

ID=`shuf -er -n3  {A..Z} | tr -d '\n'`
TESTER=AWS_JOURNEY_TESTER_$ID
DEPLOYER=AWS_JOURNEY_DEPLOYER_$ID
DEPLOYER_POLICY=AWS_JOURNEY_DEPLOYER_POLICY_$ID

sed  "s/ACCOUNT_ID/$JN_ACCOUNT_ID/g" AssumeRole.json > AssumeRole.converted.json

TESTER_ROLE=$(\
    aws iam create-role \
        --role-name $TESTER \
        --assume-role-policy-document file://AssumeRole.converted.json \
        --query 'Role.Arn' \
        --output text \
)

aws iam create-policy \
    --policy-name $DEPLOYER_POLICY \
    --policy-document file://DeployerIAMPolicy.json \
    --no-cli-pager

DEPLOYER_ROLE=$(\
    aws iam create-role \
        --role-name $DEPLOYER \
        --assume-role-policy-document file://AssumeRole.converted.json \
        --query 'Role.Arn' \
        --output text \
)

aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess --role-name $TESTER --no-cli-pager
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess --role-name $DEPLOYER --no-cli-pager
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/PowerUserAccess --role-name $DEPLOYER --no-cli-pager
aws iam attach-role-policy --policy-arn arn:aws:iam::$LOCAL_ACCOUNT_ID:policy/$DEPLOYER_POLICY --role-name $DEPLOYER --no-cli-pager

PAYLOAD="{\
    \"AccountId\": \"$LOCAL_ACCOUNT_ID\", \
    \"EnvironmentName\": \"$ENV_NAME\", \
    \"DeployerRole\": \"$DEPLOYER_ROLE\", \
    \"TesterRole\": \"$TESTER_ROLE\", \
    \"Region\": \"$REGION1\", \
    \"Region2\": \"$REGION2\", \
    \"AccessToken\": \"$ACCESS_TOKEN\"\
}"

curl --request PUT -H "Content-Type:application/json"  -H "Authorization:Bearer $ID_TOKEN" https://api-jn.aws-journey.net/account --data "$PAYLOAD"
