#! /bin/sh

test -d "./wiki" && rm -rf wiki
git clone $CLONEPATH wiki

./node_modules/.bin/tiddlywiki wiki --listen &
trap "kill $!" EXIT

