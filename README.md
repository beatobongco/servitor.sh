# servitor.sh

Tiny utility for connecting to AWS servers

## Setup

1. Download the script.
2. Fill in the required variables:
```
# --- YOUR DETAILS HERE ---
# put your AWS instance's name here. Can be anything 
INSTANCE_NAME=""
# put your AWS instance's ID. It should look like i-a2k5js92j39sk2
INSTANCE_ID=""
# put the path to your .pem keyfile
KEY_PATH="~/secrets/wow.pem"
# --- END ---
```

## Usage

Ensure you are in the directory where the script is. Run the script `./servitor.sh <command>`

### `./servitor.sh start`

Start your aws instance and ssh into it.
Sends the start signal to AWS and waits for the instance to fully start before conneting to it.

Sample output:
```
Trying to connect to beato-aws-deep... (will start it if turned off)
Instance is starting... Trying again in 1 second(s)...
Instance is starting... Trying again in 1 second(s)...
Instance is starting... Trying again in 1 second(s)...
Instance is starting... Trying again in 1 second(s)...
Instance is starting... Trying again in 1 second(s)...
Started beato-aws-deep! Connecting...
<ssh session starts>
```

### ./servitor.sh stop

Sends the stop signal to AWS and tells you when it has successfully shut down
 
Sample output:
```
Stopping beato-aws-deep... The signal has been sent, you may exit this command with CTRL+c or wait for confirmation.
beato-aws-deep successfully stopped.
```