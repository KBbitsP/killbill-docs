#!/bin/bash -e

GH_REF=github.com/killbill/killbill-docs.git
BUILD=`mktemp -d "${TMPDIR:-/tmp}"/foo.XXXX`

cp -r build $BUILD

pushd $BUILD
git clone --depth=5 --branch=gh-pages https://$GH_REF
popd

cp -f $BUILD/build/selfcontained/index.html $BUILD/killbill-docs/
# Copy assets (see make.sh)
cp -rf $BUILD/build/selfcontained/stylesheets/* $BUILD/killbill-docs/stylesheets/
cp -rf $BUILD/build/selfcontained/javascripts/* $BUILD/killbill-docs/javascripts/

VERSION=$(cat $BUILD/killbill-docs/latest.txt)
mkdir -p $BUILD/killbill-docs/$VERSION $BUILD/killbill-docs/$VERSION/stylesheets $BUILD/killbill-docs/$VERSION/javascripts
cp -f $BUILD/build/selfcontained/* $BUILD/killbill-docs/$VERSION/
cp -rf $BUILD/build/selfcontained/stylesheets/* $BUILD/killbill-docs/$VERSION/stylesheets/
cp -rf $BUILD/build/selfcontained/javascripts/* $BUILD/killbill-docs/$VERSION/javascripts/

mkdir -p $BUILD/killbill-docs/latest $BUILD/killbill-docs/latest/stylesheets $BUILD/killbill-docs/latest/javascripts
# This will also copy the manually generated files (*.xsd, ddl.sql)
cp -f $BUILD/killbill-docs/$VERSION/* $BUILD/killbill-docs/latest/
cp -rf $BUILD/killbill-docs/$VERSION/stylesheets/* $BUILD/killbill-docs/latest/stylesheets/
cp -rf $BUILD/killbill-docs/$VERSION/javascripts/* $BUILD/killbill-docs/latest/javascripts/

pushd $BUILD/killbill-docs
git config user.name "Kill Bill core team"
git config user.email "contact@killbill.io"
git add $VERSION latest stylesheets javascripts index.html
git commit -m "Docs update"
git push -f "https://${GH_TOKEN}:x-oauth-basic@${GH_REF}" gh-pages:gh-pages
popd
