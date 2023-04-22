package handler

import (
	"context"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
	"go.alekc.dev/myta-demo/types"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
)

const DYNAMO_QTD_TABLE = "DYNAMO_QTD_TABLE"

type Response events.APIGatewayProxyResponse

func Create() Handler {
	return NewHandler()
}

type Handler interface {
	Run(ctx context.Context, event events.APIGatewayCustomAuthorizerRequest) (Response, error)
}

type handler struct {
	randomName string
	awsSession *session.Session
}

func (l *handler) init() {
	// init configuration management
	viper.AutomaticEnv()
	viper.SetDefault("AWS_REGION", "us-east-1")

	// init logging
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	// sanity check
	if viper.GetString(DYNAMO_QTD_TABLE) == "" {
		log.Fatal().Msg("you need to define DYNAMO_QTD_TABLE before proceeding")
	}

	// init aws connection
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(viper.GetString("AWS_REGION")), // change this to the desired region
	})
	if err != nil {
		log.Fatal().Err(err).Msg("could not initiate AWS session")
	}
	l.awsSession = sess
}

func (l *handler) Run(ctx context.Context, event events.APIGatewayCustomAuthorizerRequest) (Response, error) {
	qtResponse := &types.QtdResponse{}
	res := Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Headers: map[string]string{
			"Access-Control-Allow-Origin":      "*",
			"Access-Control-Allow-Credentials": "true",
			"Cache-Control":                    "no-cache; no-store",
			"Content-Type":                     "application/json",
			"Content-Security-Policy":          "default-src self",
			"Strict-Transport-Security":        "max-age=31536000; includeSubDomains",
			"X-Content-Type-Options":           "nosniff",
			"X-XSS-Protection":                 "1; mode=block",
			"X-Frame-Options":                  "DENY",
		},
	}
	row, err := l.getData(ctx)
	switch {
	case err != nil:
		res.StatusCode = http.StatusInternalServerError
		qtResponse.Error = "unexpected error during execution"
	case row == nil:
		res.StatusCode = http.StatusNoContent
		qtResponse.Message = "no data is present"
	default:
		qtResponse.Message = row.Text
		qtResponse.Id = row.ID
	}
	res.Body = qtResponse.ToString()
	return res, err
}

func NewHandler() Handler {
	h := &handler{}
	h.init()
	return h
}

func (l *handler) getData(ctx context.Context) (*types.Qtd, error) {
	svc := dynamodb.New(l.awsSession)

	result, err := svc.Scan(&dynamodb.ScanInput{
		TableName: aws.String(viper.GetString(DYNAMO_QTD_TABLE)),
		Limit:     aws.Int64(1),
	})
	switch {
	case err != nil:
		log.Err(err).Msg("cannot get the data from db")
		return nil, err
	case len(result.Items) == 0:
		log.Warn().Msg("no data found in the db")
		return nil, nil
	default:
		row := &types.Qtd{}
		if err := dynamodbattribute.UnmarshalMap(result.Items[0], row); err != nil {
			log.Err(err).Msg("error while unmarshalling data from dynamodb")
			return nil, err
		}
		return row, nil
	}
}
