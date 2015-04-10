#!/usr/bin/env bash
cf login \
    -a api.run.pivotal.io \
    -u jasonnerothin@gmail.com \
    -p $CLOUD_FOUNDRY_PASSWORD \
    -o getcloudify.org \
    -s left
