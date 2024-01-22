# -*- sh -*-
###########################################################################
## $Id: stacktrace.sh 9 2018-01-18 19:43:18Z jarmstrong $
## -----------------------------------------------------------------------
## Intent  : Register an interrupt handler to generate a stack trace
##           whenever shell commands fail or prematurely exist.
## Usage   : source stacktrace.sh
## See Also: traputils.sh
##           https://gist.github.com/ahendrix/7030300
###########################################################################

###########################################################################
## set -o errexit silently exiting on error is less than helpful so use a
## call stack function to expose the problem.  This belongs in a central
## shell library repository but create as C/test/stacktrace.sh for now
###########################################################################

## -----------------------------------------------------------------------
## Intent: Display a stack trace for the caller
## -----------------------------------------------------------------------
function stacktrace()
{
    set +o xtrace

	echo "Call tree:"
    local -i max=$(( ${#FUNCNAME[@]} - 1 ))
	for ((i=1; i < $max; i++))
	do
	    echo " $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
	done
    return
}

## -----------------------------------------------------------------------
## Intent: Display a stack trace then exit
## -----------------------------------------------------------------------
function errexit()
{
    local err=$?
    set +o xtrace
    local code="${1:-1}"

    local prefix="${BASH_SOURCE[1]}:${BASH_LINENO[0]}"
    echo -e "\nOFFENDER: ${prefix}"
    if [ $# -gt 0 ] && [ "$1" == '--stacktrace-quiet' ]; then
        code=1
    else
        echo "ERROR: '${BASH_COMMAND}' exited with status $err"
    fi

    # Print out the stack trace described by $function_stack
    if [ ${#FUNCNAME[@]} -gt 2 ]
    then
	    echo "Call tree:"
	    for ((i=1;i<${#FUNCNAME[@]}-1;i++))
	    do
	        echo " $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
	    done
    fi

    echo "Exiting with status ${code}"
    echo
    exit "${code}"
}

# trap ERR to provide an error handler whenever a command exits nonzero
#  this is a more verbose version of set -o errexit
trap 'errexit' ERR
# trap 'errexit' EXIT
# trap 'errexit' DEBUG

# setting errtrace allows our ERR trap handler to be propagated to functions,
#  expansions and subshells
set -o errtrace

## Unit tests may need to disable interrupts to avoid control loss during segv
# source $(dirname ${BASH_SOURCE})/traputils.sh
source "${BASH_SOURCE[0]/stacktrace.sh/traputils.sh}"

: # NOP

# EOF
