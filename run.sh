#! /bin/sh

function init() {
    if [[ -e wiki ]]
    then
        echo "'wiki' already exists, aborting"
        exit 1
    fi

    git clone $CLONEPATH wiki
}

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


init
./node_modules/.bin/tiddlywiki wiki --listen &
wikipid=$!
cd wiki

trap "on_terminate $wikipid" EXIT
while true
do
    sleep 15s && sync_repo
done
