#!/bin/bash

curl -H "Content-Type: application/json" --data '{"source_type": "Branch", "source_name": "'$CIRCLE_BRANCH'"}' -X POST $DOCKERHUB_TRIGGER_URL
