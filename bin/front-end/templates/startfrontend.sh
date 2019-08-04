#!/usr/bin/sh

## This file is used in service file to start relevant processes.
nohup /opt/frontend/serve.py &
sleep 5 ## Just so there is time delay
java -jar front-end.jar
