package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"go.alekc.dev/myta-demo/handler"
)

func main() {
	handler := handler.Create()
	lambda.Start(handler.Run)
}
