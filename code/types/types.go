package types

import "encoding/json"

// Qtd represents data from the quote of the day table
type Qtd struct {
	ID   string
	Text string
}

type QtdResponse struct {
	Error   string `json:"error,omitempty"`
	Message string `json:"msg,omitempty"`
	Id      string `json:"ID,omitempty"`
}

// ToString returns json representation of the QtdResponse object
func (qr *QtdResponse) ToString() string {
	js, _ := json.Marshal(qr)
	return string(js)
}
