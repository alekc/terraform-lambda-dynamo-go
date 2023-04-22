package handler

import (
	"context"
	"testing"
)

func Test_handler_getData(t *testing.T) {
	l := &handler{}
	l.init()
	l.getData(context.TODO())
}
