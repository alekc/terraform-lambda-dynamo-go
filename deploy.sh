#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

printf "### Starting the building process ###\n"
mkdir -p ./bin
rm -rf ./bin

echo "### Building go packages ###"

cd code
#go test ./...
env GOOS=linux GOARCH=amd64 go build -o ../bin/qtd
cd ..

echo "### Deploying tf stack ###"
cd infra
rm -rf ./bin/

terraform init -input=false
terraform apply -input=false -auto-approve
cd ../

echo "### Done ###"
