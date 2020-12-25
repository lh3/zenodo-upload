#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [deposition id] [filename]
#

set -xe

DEPOSITION=$1
BUCKET=$(curl -H "Accept: application/json" -H "Authorization: Bearer $ZENODO_TOKEN" "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION" | jq --raw-output .links.bucket)

shift
for FILEPATH in "$@"
do
	FILENAME=$(echo $FILEPATH | sed 's+.*/++g')
	curl --progress-bar -o /dev/null --upload-file $FILEPATH $BUCKET/$FILENAME?access_token=$ZENODO_TOKEN
done
