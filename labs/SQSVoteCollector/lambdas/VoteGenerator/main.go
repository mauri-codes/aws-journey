package main

import (
	"context"
	"encoding/json"
	"log"
	"math/rand/v2"
	"os"
	"sync"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go-v2/service/sqs/types"
	"github.com/google/uuid"
	"github.com/mauri-codes/go-modules/utils"
)

var sqsClient *sqs.Client
var queueUrl string

type Favorite struct {
	Favorite string
}

func init() {
	queueUrl = os.Getenv("VOTING_QUEUE_URL")
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("Failed to load aws configuration, %v", err)
	}

	sqsClient = sqs.NewFromConfig(cfg)
}

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, event map[string]int) error {
	utils.Pr(event)
	var favGroup []string
	sqsMessages := CreateSQSMessages(event)
	messagesLength := len(sqsMessages)
	var wg sync.WaitGroup
	for ind, favorite := range sqsMessages {
		favGroup = append(favGroup, favorite)
		if ShouldSendMessages(ind, messagesLength) {
			wg.Add(1)
			messages := make([]string, len(favGroup))
			copy(messages, favGroup)
			go func() {
				defer wg.Done()
				err := SendSQSBatchMessages(messages)
				if err != nil {
					log.Fatalf("Error Sending SQS Messages %v", err)
				}
			}()
			favGroup = nil
		}
	}
	wg.Wait()
	return nil
}

func SendSQSBatchMessages(messages []string) error {
	var entries []types.SendMessageBatchRequestEntry
	for _, fav := range messages {
		id := uuid.New().String()
		entries = append(entries, types.SendMessageBatchRequestEntry{
			MessageBody: &fav,
			Id:          &id,
		})
	}
	input := sqs.SendMessageBatchInput{
		QueueUrl: &queueUrl,
		Entries:  entries,
	}
	_, err := sqsClient.SendMessageBatch(context.TODO(), &input)
	return err
}

func CreateSQSMessages(event map[string]int) []string {
	total := 0
	for _, count := range event {
		total += count
	}
	sqsMessages := make([]string, 0, total)
	for key, count := range event {
		for range count {
			stringFavorite, _ := json.Marshal(&Favorite{
				Favorite: key,
			})
			sqsMessages = append(sqsMessages, string(stringFavorite))
		}
	}
	return RandomizeSlice(sqsMessages)
}

func ShouldSendMessages(ind int, length int) bool {
	sendMessages := (ind+1)%10 == 0
	if ind == length-1 {
		sendMessages = true
	}
	return sendMessages
}

func RandomizeSlice[T any](Slice []T) []T {
	length := len(Slice)
	randomPositions := make([]int, length)
	for ind := range randomPositions {
		randomPositions[ind] = ind
	}
	for currentPos, currentPointerPos := range randomPositions {
		randomPos := randRange(0, length)
		randomPointerPos := randomPositions[randomPos]
		if randomPos != currentPos {
			randomPositions[currentPos] = randomPointerPos
			randomPositions[randomPos] = currentPointerPos
		}
	}
	newSlice := make([]T, length)
	for ind := range newSlice {
		newSlice[ind] = Slice[randomPositions[ind]]
	}
	return newSlice
}

func randRange(min, max int) int {
	return rand.IntN(max-min) + min
}
