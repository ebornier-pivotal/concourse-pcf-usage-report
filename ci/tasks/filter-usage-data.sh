#!/bin/bash


cf login -u $SYS_ADMIN_USER -p $SYS_ADMIN_PASSWORD -a $PCF_API_ENDPOINT -o system -s system --skip-ssl-validation

ls -l *

./pipeline-scripts/ci/tasks/filter.sh -trial ./orgs-usage-consolidated/report.json

ls -l *