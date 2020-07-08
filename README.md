# tiddlywiki-git-sync

'tiddlywiki-git-sync' is a script that automatically backs all TiddlyWiki
tiddles into a git repository. It is intended to be deployed to the cloud and
configured via environment variables.

## How does it work

This script on launch starts the standard TiddlyWiki node.js server that stores
tiddlers in the local directory. The script every several minutes commits
changed files to a git repository and pushes them to the remote repository. The
contents of the remote repository are retrieved on launch and removed before
the script terminates.

## How to run it

The easiest way to run the script is by using the provided docker image, either
running it locally or by deploying it to the cloud provider of choice.
Otherwise, set necessary environment variables and execute `run.sh` shell
script.

Running on Windows machines may be possible under WSL or Cygwin although, I
cannot guarantee it.

## How to configure it

The following environment variables are used as configuration:

`CLONEPATH` (required)<br>
The remote repository URL. Is authentication is required to access this
repository place the username as part of the URL: `https://<username>@<host>/path`

`CREDENTIALS` <br>
Username and password used to clone and push changes to the remote. The value
must follow the format: `https://<username>:<password>@<host>`.
[See details.](https://git-scm.com/docs/git-credential-store#_storage_format)

`COMMITER_NAME` and `COMMITER_EMAIL` <br>
Name and E-main of the commits' author. Required if git's `user.name` and
`user.email` configuration values are not set.

`PORT` <br>
TCP/IP port that the server is going to listen to. Default: 8080.

`BIND`<br>
The IP address that the server is going to bind on. Default: 127.0.0.1.

`OPTIONS`<br>
Additional options to be passed to the server.

`PERIOD`<br>
How often to perform "commit-pull-push" operation. Uses the same syntax as the
[`sleep`](https://linux.die.net/man/1/sleep) utility.

