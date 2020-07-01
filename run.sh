#! /bin/sh

test -d "./wiki" && rm -rf wiki
git clone $CLONEPATH wiki

./node_modules/.bin/tiddlywiki wiki --listen &
trap "kill $!" EXIT

function sync_repo() {
    if [[ -z "$(git status --short)" ]]
    then
        return
    fi
    git add .
    git commit -m "Automatic commit at $(date)"
    git pull --strategy-option=ours --no-edit
    git push
}

cd wiki

while true
do
    sleep 15s && sync_repo
done
