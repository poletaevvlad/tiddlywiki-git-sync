#! /bin/sh

function init() {
    if [[ -e wiki ]]
    then
        echo "'wiki' already exists, aborting"
        exit 1
    fi

    git clone $CLONEPATH wiki

    cd wiki
    git config pull.rebase false

    if [[ -n "${COMMITER_NAME}" ]]; then
        if [[ -z "${COMMITER_EMAIL}" ]]; then
            echo "if COMMITER_NAME is set then COMMITER_EMAIL must be set as well"
            cd ..
            rm -rf wiki
            exit 1
        fi

        git config user.name "$COMMITER_NAME"
        git config user.email "$COMMITER_EMAIL"
    fi

    cd ..
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
