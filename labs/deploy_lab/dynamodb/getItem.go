package aws_dynamo

import (
	"context"
	table_key "deploy_lab/dynamodb/TableKey"
	"log"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

func GetItem[T any](client *dynamodb.Client, table *table_key.TableData[any]) (T, error) {
	var item T
	pk, err := attributevalue.Marshal(table.HashKey.Value)
	if err != nil {
		return item, err
	}
	sk, err := attributevalue.Marshal(table.SortKey.Value)
	if err != nil {
		return item, err
	}

	var itemKeys = map[string]types.AttributeValue{"pk": pk, "sk": sk}
	response, err := client.GetItem(context.TODO(), &dynamodb.GetItemInput{
		Key: itemKeys, TableName: aws.String(table.TableName),
	})
	if err != nil {
		log.Printf("GetItem Error: %v\n", err)
	} else {
		err = attributevalue.UnmarshalMap(response.Item, &item)
		if err != nil {
			log.Printf("Couldn't unmarshal response: %v\n", err)
		}
	}
	return item, err
}
