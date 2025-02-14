package table_key

type TableKey struct {
	Key    string
	Value  string
	Action string
}

type TableData struct {
	TableName string
	HashKey   TableKey
	SortKey   TableKey
}

const (
	EQUALS      = "EQUALS"
	BEGINS_WITH = "BEGINS_WITH"
)
