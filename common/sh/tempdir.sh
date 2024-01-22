#!/bin/bash
## -----------------------------------------------------------------------
## $Id: tempdir.sh 9 2018-01-18 19:43:18Z jarmstrong $
## -----------------------------------------------------------------------
## Intent: Setup/teardown a scratch area for testing.
## Argument --preserve can be used to inhibit test file removal.
## -----------------------------------------------------------------------

# __DEBUG_COMMON__=1
[[ -v __DEBUG_COMMON__ ]] && echo "${BASH_SOURCE[0]}: BEGIN"

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
if [[ ! -v __COMMON_TEMP_DIRS__ ]]; then
    declare -g -a __COMMON_TEMP_DIRS__
fi

## -----------------------------------------------------------------------
## Intent: Allocate a transient tmpdir
## -----------------------------------------------------------------------
## NOTE:
##   o Caller should export TMPDIR="${path}"
##   o TMPDIR= only visible when sourced form top level parent scope
## -----------------------------------------------------------------------
function common_tempdir_mkdir()
{
    declare -n ref=$1; shift
    #    local var="$1"; shift

    local pkgbase="${0##*/}" # basename
    local pkgname="${pkgbase%.*}"

    cat <<EOF
** -----------------------------------------------------------------------
** pkgbase = ${pkgbase}
** pkgname = ${pkgname}
** -----------------------------------------------------------------------
EOF
    local __junk__
    local __junk__="$(mktemp -d -t "${pkgname}.XXXXXXXXXX")"
    
    __COMMON_TEMP_DIRS__+=("$__junk__")

    export TMPDIR="$__junk__"
    # eval "${var}=${__junk__}"
    ref="${__junk__}"

    # declare -p __COMMON_TEMP_DIRS__
    return
}

## -----------------------------------------------------------------------
## Intent: Preserve allocated temp directories on exit
## -----------------------------------------------------------------------
## Usage:
##   o kill -s 'SIGSYS' $$
## -----------------------------------------------------------------------
function sigtrap_preserve()
{
    local dir
    for dir in "${__COMMON_TEMP_DIRS__[@]}";
    do
        touch "$dir/.preserve"
    done
}
trap sigtrap_preserve SIGSYS

## -----------------------------------------------------------------------
## Intent: Tempdir cleanup on exit
## -----------------------------------------------------------------------
function sigtrap()
{
    local dir
    for dir in "${__COMMON_TEMP_DIRS__[@]}";
    do
        if [ -e "$dir/.preserve" ]; then
            echo "Preserving test output: $TMPDIR"
            find "$TMPDIR" -ls
        else
            /bin/rm -fr "$TMPDIR"
        fi
    done
}
trap sigtrap EXIT

[[ -v __DEBUG_COMMON__ ]] && echo "${BASH_SOURCE[0]}: END"
unset __DEBUG_COMMON__

: # NOP

# [EOF]
