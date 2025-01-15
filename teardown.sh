#!/bin/bash

# load environment data.
source .env

# deploy vault.
./00-Other/vault/teardown.sh

# deploy demos
echo 'Teardown 01-HelloBicep'
./01-HelloBicep/teardown.sh
echo 'Teardown 02-Variables'
./02-Variables/teardown.sh
echo 'Teardown 03-Scopes'
./03-Scopes/teardown.sh
echo 'Teardown 04-Modules (no_modules)'
./04-Modules/no_modules/teardown.sh
echo 'Teardown 04-Modules'
./04-Modules/teardown.sh
echo 'Teardown 05-Conditionals'
./05-Conditionals/teardown.sh
echo 'Teardown 06-Loops'
./06-Loops/teardown.sh