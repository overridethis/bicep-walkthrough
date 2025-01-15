#!/bin/bash

# load environment data.
source .env

# deploy vault.
./00-Other/vault/teardown.sh

# deploy demos
./01-HelloBicep/teardown.sh
./02-Parameters/teardown.sh
./03-Outputs/teardown.sh
./04-Modules/teardown.sh
./05-Conditionals/teardown.sh
./06-Loops/teardown.sh