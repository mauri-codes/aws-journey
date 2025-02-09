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

func UpdateItem[T any](client *dynamodb.Client, table *table_key.TableData[T]) error {
	var err error
	var itemKeys map[string]types.AttributeValue
	pk, err := attributevalue.Marshal(table.HashKey.Value)
	if err != nil {
		return err
	}
	if table.SortKey.Value != "" {
		sk, err := attributevalue.Marshal(table.SortKey.Value)
		if err != nil {
			return err
		}
		itemKeys = map[string]types.AttributeValue{table.HashKey.Key: pk, table.SortKey.Key: sk}
	} else {
		itemKeys = map[string]types.AttributeValue{table.HashKey.Key: pk}
	}
	exp := table.Expression
	_, err = client.UpdateItem(context.TODO(), &dynamodb.UpdateItemInput{
		TableName:                 aws.String(table.TableName),
		Key:                       itemKeys,
		ExpressionAttributeNames:  exp.Names(),
		ExpressionAttributeValues: exp.Values(),
		UpdateExpression:          exp.Update(),
		ReturnValues:              types.ReturnValueUpdatedNew,
	})
	if err != nil {
		log.Printf("Couldn't update item: %v\n", err)
	}
	return err
}
