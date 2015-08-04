#!/bin/bash

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST $DOCKERHUB_TRIGGER_URL
