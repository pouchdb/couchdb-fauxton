#!/usr/bin/env bash

set -x
set -e

#
# The main goal of this script is to customize Fauxton to our liking.
# We alter it, rebuild it, and then move the built assets into /fauxton
#

GIT_HASH=61c2681

FAUXTON_SRC=$(pwd)/fauxton-src
REPLACE=$(pwd)/node_modules/.bin/replace
WWW_TARGET=$(pwd)/www
CURRENT_WD=$(pwd)

rm -fr ${FAUXTON_SRC}
git clone https://github.com/apache/couchdb-fauxton.git \
  --branch master --single-branch ${FAUXTON_SRC}
cd ${FAUXTON_SRC}
git checkout ${GIT_HASH}
cd ${CURRENT_WD}

# changing these less variables will have a cascading effect across the
# entire CSS. changing the CSS itself would be extremely messy in comparison
${REPLACE} \
  "@brandPrimary: @red;" \
  "@brandPrimary: darken(#6ccb99, 5%);" \
  ${FAUXTON_SRC}/assets/less/variables.less
${REPLACE} \
  "@brandPrimaryDark: @darkRed;" \
  "@brandPrimaryDark: darken(@brandPrimary, 10%);" \
  ${FAUXTON_SRC}/assets/less/variables.less

# currently no way to configure this, so we search-and-replace the site title
# and favicon in index.underscore
${REPLACE} \
  "Project Fauxton" "PouchDB Server" \
  ${FAUXTON_SRC}/assets/index.underscore
${REPLACE} \
  "dashboard.assets/img/couchdb-logo.png" \
  "dashboard.assets/img/pouchdb-favicon.ico" \
  ${FAUXTON_SRC}/assets/index.underscore

# another thing it'd be nice to change with a variable: the footer at the
# bottom of the page
${REPLACE} \
  "http://couchdb.apache.org/" "https://github.com/pouchdb/express-pouchdb/" \
  ${FAUXTON_SRC}/app/addons/fauxton/navigation/components.react.jsx
${REPLACE} \
  "Apache CouchDB" "express-pouchdb" \
  ${FAUXTON_SRC}/app/addons/fauxton/navigation/components.react.jsx

# merge fauxton-merge with ${FAUXTON_SRC}
# these config files are consumed by Fauxton during build as "addons"
for filename in `find fauxton-merge -type d | sed 's/fauxton-merge\///'g`; do
  mkdir -p "${FAUXTON_SRC}/$filename"
done

for filename in `find fauxton-merge -type f | sed 's/fauxton-merge\///'g`; do
  cp "fauxton-merge/$filename" "${FAUXTON_SRC}/$filename"
done

# rebuild fauxton
cd ${FAUXTON_SRC}
npm install
npm run couchdb
cd ${CURRENT_WD}

rm -fr ${WWW_TARGET}
cp -r ${FAUXTON_SRC}/dist/release ${WWW_TARGET}
