package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"go.alekc.dev/myta-demo/handler"
)

func main() {
	qtdHandler := handler.Create()
	lambda.Start(qtdHandler.Run)
}
