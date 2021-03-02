#!/bin/bash

readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

VERSION=$(cat ${SCRIPT_DIR}/../package.json | grep version | cut -d '"' -f4)

git tag v${VERSION} -m "Tagging release version: ${VERSION}"

git push origin v${VERSION}

LAST_VERSION_DIGIT=$(echo ${VERSION} | rev | cut -d '.' -f1)

NEW_LAST_VERSION_DIGIT=$(( ${LAST_VERSION_DIGIT} + 1 ))

NEW_VERSION=$(echo "${VERSION}" | rev | sed -E "s/^([0-9]{1,3})\.(.*)$/${NEW_LAST_VERSION_DIGIT}\.\2/g" | rev)

echo ${NEW_VERSION}

sed -i "s/\"version\": \"${VERSION}\"/\"version\": \"${NEW_VERSION}\"/g" ${SCRIPT_DIR}/../package.json

git add ${SCRIPT_DIR}/../package.json

git commit -am "chore(release): upversion package.json post release"

git push origin master