# -*- sh -*-
###########################################################################
## Usage:  source common.sh --tempdir --traputils
###########################################################################

# __DEBUG_COMMON__=1
[[ -v __DEBUG_COMMON__ ]] && echo " ** ${BASH_SOURCE[0]}: BEGIN"

## -----------------------------------------------------------------------
## Intent: Anonymous function used to source common shell libs
## -----------------------------------------------------------------------
## Usage: source common.sh '--stacktrace'
## -----------------------------------------------------------------------
function __anon_func__()
{
    local iam="${BASH_SOURCE[0]%/*}"
    local cab='--common-args-begin--'

    declare -a args=($*)

    # -------------------------------------------------------------
    # Derive path to repository sandbox root
    # repo:onf-common may be a git-subdir so explicitly derive path
    # -------------------------------------------------------------
    local raw
    raw="$(readlink --canonicalize-existing --no-newline "${BASH_SOURCE[0]}")"

    local top="$raw"  # repo:onf-urls/common.sh
    top="${top%/*}"   # repo:onf-urls/

    local top="${raw%/*}"
    local common="${top}/common/sh"

    local arg
    for arg in "${args[@]}";
    do
	    case "$arg" in
	        --detect)     source "${common}"/detect-cmd-path.sh ;;
	        --tempdir)    source "${common}"/tempdir.sh    ;;
	        --traputils)  source "${common}"/traputils.sh  ;;
	        --stacktrace) source "${common}"/stacktrace.sh ;;
		"$cab") continue ;;
            *) echo "ERROR ${BASH_SOURCE[0]}: [SKIP] unknown switch=$arg" ;;
	    esac
    done

    return
}

##----------------##
##---]  MAIN  [---##
##----------------##

if [ $# -gt 0 ] && [ "$1" == '--common-args-begin--' ]; then
    shift # remove arg marker
fi

if [ $# -eq 0 ]; then
    # common.sh defaults
    set -- '--tempdir' '--traputils' '--stacktrace' '--common-args-begin--'
fi

__anon_func__ "$@"
unset __anon_func__

source "${BASH_SOURCE[0]%/*}/preserve_argv.sh" # popd @ARGV

[[ -v __DEBUG_COMMON__ ]] && echo " ** ${BASH_SOURCE[0]}: END"
: # NOP

# [EOF]
