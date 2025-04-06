ACCOUNT_ID=$1
USER_NAME=$2
ENV_NAME=$3
LOCAL_ACCOUNT_ID=`aws sts get-caller-identity --query 'Account' --output text`

ID=`shuf -er -n3  {A..Z} | tr -d '\n'`
TESTER=TESTER_$ID
DEPLOYER=DEPLOYER_$ID
DEPLOYER_POLICY=DeployerIamPolicy_$ID

sed  "s/ACCOUNT_ID/$ACCOUNT_ID/g" AssumeRole.json > AssumeRole.converted.json

aws iam create-role \
    --role-name $TESTER \
    --assume-role-policy-document file://AssumeRole.converted.json \
    --no-cli-pager

aws iam create-policy \
    --policy-name $DEPLOYER_POLICY \
    --policy-document file://DeployerIAMPolicy.json \
    --no-cli-pager

aws iam create-role \
    --role-name $DEPLOYER \
    --assume-role-policy-document file://AssumeRole.converted.json \
    --no-cli-pager

aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess --role-name $TESTER --no-cli-pager
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess --role-name $DEPLOYER --no-cli-pager
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/PowerUserAccess --role-name $DEPLOYER --no-cli-pager
aws iam attach-role-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$DEPLOYER_POLICY --role-name $DEPLOYER --no-cli-pager
