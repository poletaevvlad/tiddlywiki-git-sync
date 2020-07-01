#! /bin/sh

function on_terminate() {
    pid=$1
    kill -int $pid

    while $(kill -0 $pid 2> /dev/null)
    do
        sleep 1
    done

    sync_repo
    cd ..
    rm -rf wiki
}


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


test -d "./wiki" && rm -rf wiki
git clone $CLONEPATH wiki

./node_modules/.bin/tiddlywiki wiki --listen &
wikipid=$!

trap "on_terminate $wikipid" EXIT

cd wiki

while true
do
    sleep 15s && sync_repo
done
