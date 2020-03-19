
#!/bin/bash

# Usage ./servitor

# --- YOUR DETAILS HERE ---
# put your AWS instance's name here. Can be anything 
INSTANCE_NAME=""
# put your AWS instance's ID. It should look like i-a2k5js92j39sk2
INSTANCE_ID=""
# put the path to your .pem keyfile
KEY_PATH="~/secrets/wow.pem"
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
            echo "Instance is starting... Trying again in $SLEEP_TIME seconds..."
        fi
        # wait a second and repeat the loop until we can connect
        sleep $SLEEP_TIME
    done
    echo "Started $INSTANCE_NAME! Connecting..."
    # give a little sleep
    sleep $SLEEP_TIME
    ssh -i $KEY_PATH ubuntu@52.221.123.85
}

function stop {
    echo "Stopping $INSTANCE_NAME... The signal has been sent, you may exit this command or wait for confirmation."
    while [ "stopped" != $(aws ec2 stop-instances --instance-ids $INSTANCE_ID | parseJson "['StoppingInstances'][0]['CurrentState']['Name']") ]; do          
        sleep $SLEEP_TIME
    done
    echo "$INSTANCE_NAME successfully stopped."
}

if [ "$1" == "start" ]; then
    start
elif [ "$1" == "stop" ]; then
    stop
fi