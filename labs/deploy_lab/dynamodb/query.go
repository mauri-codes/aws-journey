package aws_dynamo

import (
	"context"
	table_key "deploy_lab/dynamodb/TableKey"
	"log"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

func Query[T any](client *dynamodb.Client, table *table_key.TableData[any]) ([]T, error) {
	hash := expression.Key(table.HashKey.Key).Equal(expression.Value(table.HashKey.Value))
	var sort expression.KeyConditionBuilder
	if table.SortKey.Action == table_key.BEGINS_WITH {
		sort = expression.Key(table.SortKey.Key).BeginsWith(table.SortKey.Value)
	} else {
		sort = expression.Key(table.SortKey.Key).Equal(expression.Value(table.SortKey.Value))
	}
	expr, err := expression.NewBuilder().WithKeyCondition(hash.And(sort)).Build()
	var queryResponse *dynamodb.QueryOutput
	var data []T
	if err != nil {
		log.Printf("Couldn't build expression for query: %v\n", err)
	} else {
		queryPaginator := dynamodb.NewQueryPaginator(client, &dynamodb.QueryInput{
			TableName:                 aws.String(table.TableName),
			ExpressionAttributeNames:  expr.Names(),
			ExpressionAttributeValues: expr.Values(),
			KeyConditionExpression:    expr.KeyCondition(),
		})
		for queryPaginator.HasMorePages() {
			queryResponse, err = queryPaginator.NextPage(context.TODO())
			if err != nil {
				log.Printf("Couldn't query for data: %v\n", err)
				break
			} else {
				var moviePage []T
				err = attributevalue.UnmarshalListOfMaps(queryResponse.Items, &moviePage)
				if err != nil {
					log.Printf("Couldn't unmarshal query response: %v\n", err)
					break
				} else {
					data = append(data, moviePage...)
				}
			}
		}
	}
	return data, err
}
