#!/usr/bin/env bash

args=("$@")

readonly API_URL=${args[0]}
test "${API_URL}" == '' && (echo "API_URL not provided as 1st argument."; exit 1)
readonly ORGANIZATION=${args[1]}
test "${ORGANIZATION}" == '' && (echo "ORGANIZATION not provided as 2nd argument."; exit 1)
readonly SPACE_NAME=${args[2]}
test "${SPACE_NAME}" == '' && (echo "SPACE_NAME not provided as 3rd argument."; exit 1)
readonly USERNAME=${args[3]}
test "${USERNAME}" == '' && (echo "USERNAME not provided as 4th argument."; exit 1)
readonly PASSWD=${args[4]}
test "${PASSWD}" == '' && (echo "PASSWD not provided as 5th argument."; return 1)

echo "cf login -a ${API_URL} -o ${ORGANIZATION} -s ${SPACE_NAME} -u ${USERNAME} -p ********* "
cf login -a ${API_URL} -o ${ORGANIZATION} -s ${SPACE_NAME} -u ${USERNAME} -p ${PASSWD}
