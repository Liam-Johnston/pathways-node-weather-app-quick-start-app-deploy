#!/bin/bash -eu

cd ./weather-app && docker build -t $APP_NAME -f weather-app-dockerfile .
