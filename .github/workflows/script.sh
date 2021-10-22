#!/bin/bash
set -eu

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [ $# -lt 1 ]
  then
    echo "Missing arguments.\nRequired arguments are [Next release]"
    exit 1
fi

API_HEADER="Accept: application/vnd.github.v3+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

getMilestone() {
  milestones=`curl -sSL \
    -H "Content-Type: application/json" \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -X "GET" \
"https://api.github.com/repos/${GITHUB_REPOSITORY}/milestones"`
milestone=`echo "${milestones}" | jq '.title'`
echo ${milestone}
}

milestones=$(getMilestone)
new_release=`echo "${milestones}" | jq '.[-1].title'`
last_release=`echo "${milestones}" | jq '.[-2].title'`


echo "new_release :"
echo "${new_release}"

echo "last_release :"
echo "${last_release}"

echo "next release: "
echo "$1"

if [[  "$new_release" == "null"  ]]; then
  echo "no new release"
  exit 1
elif [[  "$last_release" == "null"  ]]; then
  echo "no last release"
  exit 1
else
  echo "milestone is set up"
  exit 0
fi
