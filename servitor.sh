#!/bin/bash

# Usage: 
# ./servitor.sh start - turn on vm, wait until on, then ssh into it
# ./servitor.sh stop - turn off vm, tells you when it's completely off

# --- YOUR DETAILS HERE ---
# put your AWS instance's name here. Can be anything 
INSTANCE_NAME=""
# put your AWS instance's ID. It should look like i-a2k5js92j39sk2
INSTANCE_ID=""
# put the path to your .pem keyfile
KEY_PATH="~/secrets/wow.pem"
# example "ubuntu@12.123.456.78"
INSTANCE_ADDRESS=""
# --- END ---

# so we dont spam
SLEEP_TIME=1

function parseJson {
    # Usage: echo "{'cat': 5}" | parseJson "['cat']"
    # output -> "5" 
    python3 -c "import fileinput, json; print(json.loads(''.join([line for line in fileinput.input()]))$1)"
}

function start {
    echo "Trying to connect to $INSTANCE_NAME... (will start it if turned off)"
    RESULT="not running"
    while true; do
        # get the JSON response from aws CLI
        # pipe it to python, reading from STDIN
        # this python script will read the JSON. We will check if this instance is now running
        RESULT=$(aws ec2 start-instances --instance-ids $INSTANCE_ID | parseJson "['StartingInstances'][0]['CurrentState']['Name']")
        if [ "$RESULT" == "running" ]; then
            break
        else
            echo "Instance is starting... Trying again in $SLEEP_TIME second(s)..."
        fi
        # wait a second and repeat the loop until we can connect
        sleep $SLEEP_TIME
    done
    echo "Started $INSTANCE_NAME! Connecting..."
    # give a little sleep
    sleep $SLEEP_TIME
    ssh -i $KEY_PATH $INSTANCE_ADDRESS
}

function stop {
    echo "Stopping $INSTANCE_NAME... The signal has been sent, you may exit this command (CTRL+C) or wait for confirmation."
    while [ "stopped" != $(aws ec2 stop-instances --instance-ids $INSTANCE_ID | parseJson "['StoppingInstances'][0]['CurrentState']['Name']") ]; do          
        sleep $SLEEP_TIME
    done
    echo "$INSTANCE_NAME is stopped."
}

if [ "$1" == "start" ]; then
    start
elif [ "$1" == "stop" ]; then
    stop
fi