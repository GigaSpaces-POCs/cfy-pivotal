#!/usr/bin/env bash
readonly DROPLET_SIZE=512M

# INPUT PARSING AND VALIDATION
args=("$@")
readonly APPLICATION_NAME=args[1]
test "${APPLICATION_NAME}" == '' && (echo "APPLICATION_NAME not provided as 1st arg."; exit 1)
readonly DELTA=args[2]
test "${DELTA}" == '' && (echo "DELTA not provided as 2nd arg."; exit 1)

# QUERY SYSTEM FOR CURRENT STATUS TO MAKE SURE WE SHOULD ATTEMPT TO SCALE
readonly CURRENT_INSTANCE_COUNT=$( cf a | tail -1 | awk '{ print $3 }' | sed 's/\// /' | awk '{ print $2 }' )
test "${CURRENT_INSTANCE_COUNT}" == '' && (echo "Error calculating current CloudFoundry App instance count."; exit 1)
test ${CURRENT_INSTANCE_COUNT} -eq 0 && (echo "Cannot scale a CloudFoundry App that has not been deployed (i.e. 'pushed' in CloudFoundry terminology)."; exit 1)
readonly FINAL_INSTANCE_COUNT=$((CURRENT_INSTANCE_COUNT + DELTA))

# CHATTER A LITTLE
echo "There are currently ${CURRENT_INSTANCE_COUNT} CloudFoundry App instances running."
if [ ${DELTA} -lt 0 ]; then
    MAGNITUDE=$(($DELTA*-1))
    echo "Decreasing the number of deployed CloudFoundry App instances by ${MAGNITUDE}."
else
    echo "Increasing the number of deployed CloudFoundry App instances by ${DELTA}."
fi

# DO SOMETHING USEFUL
echo "cf scale ${APPLICATION_NAME} -i ${FINAL_INSTANCE_COUNT} -m ${DROPLET_SIZE} -f"
cf scale ${APPLICATION_NAME} -i ${FINAL_INSTANCE_COUNT} -m ${DROPLET_SIZE} -f
echo "Scale operation complete. Final App instance count = ${FINAL_INSTANCE_COUNT}."