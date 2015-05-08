#! /bin/bash -e
ctx logger info "Executing CF push..."

args=("$@")
readonly APPLICATION_NAME=${args[1]}
test "${APPLICATION_NAME}" == '' && (echo "No application name provided to cf push command."; exit 1)

ctx logger info "cf push ${APPLICATION_NAME}"
cf push ${APPLICATION_NAME}

ctx logger info "CF push was successful."