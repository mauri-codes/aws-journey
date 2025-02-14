package main

import (
	"context"
	data_schemas "deploy_labs/dataSchemas"
	aws_dynamo "deploy_labs/dynamodb"
	table_key "deploy_labs/dynamodb/TableKey"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

func main() {
	// APP_TABLE := os.Getenv("APP_TABLE")
	// USER_ID := os.Getenv("USER_ID")
	APP_TABLE := "aws-journey"
	USER_ID := "test1"

	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("failed to load configuration, %v", err)
	}
	dbClient := dynamodb.NewFromConfig(cfg)

	accountData, err := aws_dynamo.Query[data_schemas.UserAccounts](
		dbClient,
		&table_key.TableData{
			TableName: APP_TABLE,
			HashKey: table_key.TableKey{
				Key:    "pk",
				Value:  "user_" + USER_ID,
				Action: table_key.EQUALS,
			},
			SortKey: table_key.TableKey{
				Key:    "sk",
				Value:  "accounts",
				Action: table_key.EQUALS,
			},
		},
	)

	if err != nil {
		log.Printf("Error: %v\n", err)
		log.Fatal(err)
	}
	Pr(accountData)

	fmt.Print("Enter your name: ")
	x := os.Getenv("TF_VAR_bucket_name")
	cmd, err := exec.Command("terraform", "--version").Output()
	fi := string(cmd)
	fmt.Println(x)
	fmt.Println(fi)
	fmt.Println(err)
}

func Pr(data any) {
	res4B, _ := json.MarshalIndent(data, "", "\t")
	fmt.Println(string(res4B))
}
