#!/bin/bash

## -----------------------------------------------------------------------
## Intent: Display an error message then exit
## -----------------------------------------------------------------------
## TODO:
##   o Add optional depth argument to display FUNCNAME[depth].
## -----------------------------------------------------------------------
function error()
{
    cat <<EOF

** -----------------------------------------------------------------------
** IAM: ${BASH_SOURCE}::${FUNCNAME[1]}
** ERROR: $@
** -----------------------------------------------------------------------
EOF

    exit 1
}

## -----------------------------------------------------------------------
## Intent: Display a status mesage labeled
## -----------------------------------------------------------------------
function func_echo()
{
    cat <<EOF

** -----------------------------------------------------------------------
** IAM: ${BASH_SOURCE}::${FUNCNAME[1]}
** ERROR: $@
** -----------------------------------------------------------------------
EOF

    exit 1
}

## -----------------------------------------------------------------------
## Intent: Display a mesasge with banner output for visibility
## -----------------------------------------------------------------------
function banner()
{
    local -a msg=("$@")
    cat <<EOM

** -----------------------------------------------------------------------
** IAM: ${BASH_SOURCE}::${FUNCNAME}
EOM

    for msg in "$@"; do
        printf '** %s\n' "$msg"
    done

    cat <<EOM
** -----------------------------------------------------------------------
EOM
    return
}

# [EOF] - 20231222: Ignore, this triage patch will be abandoned
