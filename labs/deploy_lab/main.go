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
	userAccounts, err := GetAccountData(dbClient, APP_TABLE, USER_ID)
	if err != nil {
		log.Printf("Error: %v\n", err)
	}
	Pr(userAccounts)
	err = os.Setenv("ACCOUNT1_ROLE", userAccounts.Account_A)
	if err != nil {
		log.Fatalf("err %v", err)
	}
	err = os.Setenv("REGION_A", userAccounts.Region_A)
	if err != nil {
		log.Fatalf("err %v", err)
	}

	fmt.Print("Enter your name: ")
	x := os.Getenv("TF_VAR_bucket_name")
	cmd, err := exec.Command("terraform", "--version").Output()
	fi := string(cmd)
	fmt.Println(x)
	fmt.Println(fi)
	fmt.Println(err)
}

func GetAccountData(dbClient *dynamodb.Client, table string, user string) (data_schemas.UserAccounts, error) {
	userAccounts, err := aws_dynamo.GetItem[data_schemas.UserAccounts](
		dbClient,
		&table_key.TableData{
			TableName: table,
			HashKey: table_key.TableKey{
				Key:   "pk",
				Value: "user_" + user,
			},
			SortKey: table_key.TableKey{
				Key:   "sk",
				Value: "accounts",
			},
		},
	)
	if err == nil {
		if userAccounts.Account_B == "" {
			userAccounts.Account_B = userAccounts.Account_A
		}
	}
	return userAccounts, err
}

func Pr(data any) {
	res4B, _ := json.MarshalIndent(data, "", "\t")
	fmt.Println(string(res4B))
}
