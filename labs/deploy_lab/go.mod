module deploy_lab

go 1.23.2

replace github.com/mauri-codes/aws-journey/lambdas/deployer/Common => ../../lambdas/deployer/Common

require (
	github.com/aws/aws-sdk-go-v2 v1.36.2
	github.com/aws/aws-sdk-go-v2/config v1.29.6
	github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue v1.18.5
	github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression v1.7.71
	github.com/aws/aws-sdk-go-v2/service/dynamodb v1.40.2
)

require (
	github.com/aws/aws-sdk-go-v2/credentials v1.17.59 // indirect
	github.com/aws/aws-sdk-go-v2/feature/ec2/imds v1.16.28 // indirect
	github.com/aws/aws-sdk-go-v2/internal/configsources v1.3.33 // indirect
	github.com/aws/aws-sdk-go-v2/internal/endpoints/v2 v2.6.33 // indirect
	github.com/aws/aws-sdk-go-v2/internal/ini v1.8.2 // indirect
	github.com/aws/aws-sdk-go-v2/service/dynamodbstreams v1.24.21 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/accept-encoding v1.12.3 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/endpoint-discovery v1.10.14 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/presigned-url v1.12.13 // indirect
	github.com/aws/aws-sdk-go-v2/service/sso v1.24.15 // indirect
	github.com/aws/aws-sdk-go-v2/service/ssooidc v1.28.14 // indirect
	github.com/aws/aws-sdk-go-v2/service/sts v1.33.14 // indirect
	github.com/aws/smithy-go v1.22.2 // indirect
	github.com/mauri-codes/aws-journey/lambdas/deployer/Common v0.0.0-20250221060851-9502f9e4e1e6 // indirect
	github.com/mauri-codes/go-modules/aws/dynamo v0.0.0-20250407063948-6e5d35f64727 // indirect
)
