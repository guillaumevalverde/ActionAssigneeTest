#!/bin/bash
set -eu
if [ $# -lt 1 ]
  then
    echo "Missing arguments.\nRequired arguments are [GITHUB_TOKEN]"
    exit 1
fi

GITHUB_TOKEN=$1
API_HEADER="Accept: application/vnd.github.v3+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

getMilestone() {
  echo `curl -sSL \
    -H "Content-Type: application/json" \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -X "GET" \
"https://api.github.com/repos/${GITHUB_REPOSITORY}/milestones"`
}

milestones=$(getMilestone)
new_release=`echo "${milestones}" | jq -r '.[-1].title'`
last_release=`echo "${milestones}" | jq -r '.[-2].title'`

echo "new_release :"
echo "${new_release}"

echo "last_release :"
echo "${last_release}"

if [[  "$new_release" == "null"  ]]; then
  echo "no NEW_RELEASE milestones, check milestones set up"
  exit 1
elif [[  "$last_release" == "null"  ]]; then
  echo "no LAST_RELEASE milestones. check set up"
  exit 1
else
  echo "NEW_RELEASE=$new_release" >> $GITHUB_ENV
  echo "LAST_RELEASE=$last_release" >> $GITHUB_ENV
  echo "NEW_RELEASE and LAST_RELEASE set up in github env"
  exit 0
fi
