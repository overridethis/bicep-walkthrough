#!/bin/bash

# load environment data.
source .env

# deploy vault.
./00-Other/vault/deploy.sh

# deploy demos
echo 'Deploying 01-HelloBicep'
./01-HelloBicep/deploy.sh
echo 'Deploying 02-Variables'
./02-Variables/deploy.sh
echo 'Deploying 03-Scopes'
./03-Scopes/deploy.sh
echo 'Deploying 04-Modules (no_modules)'
./04-Modules/no_modules/deploy.sh
echo 'Deploying 04-Modules'
./04-Modules/deploy.sh
echo 'Deploying 05-Conditionals'
./05-Conditionals/deploy.sh
echo 'Deploying 06-Loops'
./06-Loops/deploy.sh