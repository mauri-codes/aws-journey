package aws_dynamo

import (
	"context"
	table_key "deploy_lab/dynamodb/TableKey"
	"log"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

func PutItem[T any](client *dynamodb.Client, table *table_key.TableData[T]) error {
	item, err := attributevalue.MarshalMap(table.Data)
	if err != nil {
		return err
	}
	_, err = client.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String(table.TableName), Item: item,
	})
	if err != nil {
		log.Printf("Couldn't add item to table: %v\n", err)
	}
	return err
}
