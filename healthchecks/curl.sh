#!/bin/bash
set -eo pipefail

curl -sf -X 'GET' \
  'http://localhost:3000/healthcheck' \
  -H 'accept: application/json'
