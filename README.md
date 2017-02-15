pouchdb-fauxton
====

Fork/modification of [couchdb-fauxton](https://github.com/apache/couchdb-fauxton) designed for [pouchdb-server](https://github.com/pouchdb/pouchdb-server) and [express-pouchdb](https://github.com/pouchdb/express-pouchdb)

## Usage

    npm install pouchdb-fauxton

The web files are in `www/`.

## Description

How it works:

1. Check out the couchdb-fauxton source from Github
2. Apply some transformations to style it
3. Build couchdb-fauxton from source
4. Publish the built files to npm

Why a separate repo? It takes a while to build couchdb-fauxton, and it would be painful to build couchdb-fauxton from source just to build express-pouchdb/pouchdb-server, so by putting it in a separate module we can just deploy the built files to npm.

## Development

To update this project to a later version of Fauxton, you'll need to change the `GIT_HASH` in `prepublish.sh`.

To hack on pouchdb-server/express-pouchdb while updating Fauxton, you'll just need to npm link it:

    cd path/to/pouchdb-fauxton
    npm link
    cd path/to/express-pouchdb
    npm link pouchdb-fauxton

You can also link `express-pouchdb` to `pouchdb-server` in this manner.
