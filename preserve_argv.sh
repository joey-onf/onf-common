# -*- sh -*-
###########################################################################
## Usage:  source preserve_argv.sh
###########################################################################

# __DEBUG_COMMON__=1
[[ -v __DEBUG_COMMON__ ]] && echo " ** ${BASH_SOURCE[0]}: BEGIN"

## -----------------------------------------------------------------------
## Intent: Preserve command line args allowing common.sh sourcing.
## -----------------------------------------------------------------------
## Required: Caller is required to inline and shift the @ARGV {cab} marker
## -----------------------------------------------------------------------
## Usage: source preserve_argv.sh
##   source "$(OPT_ROOT}"/common/common.sh --common-args-begin-- --stacktrace
## -----------------------------------------------------------------------
function __anon_func_preserve_argv__()
{
    local key='__preserve_argv_stack__'
    local cab='--common-args-begin--'
    local iam="${BASH_SOURCE[0]%/*}"
    
    if [[ ! -v __preserve_argv_stack__ ]]; then
	## Corner case: simple script, source w/o arguments
	if [[ $# -eq 0 ]]; then
	    set -- "$cab"
	fi
    fi

    if [[ -v __preserve_argv_stack__ ]]; then
        # echo " ** ${iam}: [POPD] environment: ${__preserve_argv_stack__[@]}"
        set -- "${__preserve_argv_stack__[@]}"
        unset __preserve_argv_stack__
    elif [ "$1" != "$cab" ]; then
        echo " ** ${iam}::${FUNCNAME} ERROR: ARGV marker not found: ${cab}"
        echo " ** command: $0"
        exit 1
    else
        ## caller (common.sh) shift {cab} from argv
        declare -g -a __preserve_argv_stack__=("$@")
        # echo " ** ${iam}: [PUSHD] environment: ${__preserve_argv_stack__[@]}"
    fi

    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
__anon_func_preserve_argv__ "$@"
unset __anon_func_preserve_argv__

[[ -v __DEBUG_COMMON__ ]] && echo " ** ${BASH_SOURCE[0]}: CLOSE"

: # NOP for set -e -vs- [[ -v __DEBUG_COMMON__ ]]

# [EOF]
