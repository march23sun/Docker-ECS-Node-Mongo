#!/usr/bin/env expect
set username $::env(CODECOMMIT_USER)
set pass $::env(CODECOMMIT_PWD)
set repoRegion $::env(CODECOMMIT_REGION)
set repoName $::env(CODECOMMIT_NAME)

if { [file exists /node/src/package.json] } {
	cd /node/src/
	spawn git pull
} else {
	spawn git clone  "https://git-codecommit.${repoRegion}.amazonaws.com/v1/repos/${repoName}" /node/src
}

expect -re "Username for 'https://git-codecommit.${repoRegion}.amazonaws.com':"
send "${username}\r"

expect -re "Password for 'https://${username}@git-codecommit.${repoRegion}.amazonaws.com':"
send "${pass}\r"


expect eof
