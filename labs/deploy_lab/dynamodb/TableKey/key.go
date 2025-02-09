package table_key

import "github.com/aws/aws-sdk-go-v2/feature/dynamodb/expression"

type TableKey struct {
	Key    string
	Value  string
	Action string
}

type TableData[T any] struct {
	TableName  string
	HashKey    TableKey
	SortKey    TableKey
	Data       T
	Expression expression.Expression
}

const (
	EQUALS      = "EQUALS"
	BEGINS_WITH = "BEGINS_WITH"
)
