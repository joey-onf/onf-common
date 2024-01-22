# -*- sh -*-
###########################################################################
## $Id: traputils.sh 9 2018-01-18 19:43:18Z jarmstrong $
## -----------------------------------------------------------------------
## Intent: Helper script for disabling shell interrupt handlers
## Usage:  source traputils.sh
###########################################################################

trap_stack_name()
{
    local sig=${1//[^a-zA-Z0-9]/_}
    echo "__trap_stack_${sig}"
}

extract_trap()
{
    echo ${@:3:$(($#-3))}
}

get_trap()
{
    eval echo $(extract_trap `trap -p $1`)
}

## -----------------------------------------------------------------------
## Intent: Push current signal handler so a new one can be installed.
## -----------------------------------------------------------------------
## Usage:
##   trap_push 'func_one' 'SIGUSR1' 'SIGUSR2'
##   trap_push 'func_two' 'SIGUSR1' 'SIGUSR2'
##   kill -s 'SIGUSR1'   # func_two()
##   trap_pop 'SIGUSR1'
##   kill -s 'SIGUSR1'   # func_one()
##   kill -s 'SIGUSR2'   # func_two()
## -----------------------------------------------------------------------
trap_push()
{
    local new_trap="$1"; shift
    declare -a sigs=($*)
    
    # local sigs=$*
    local sig
    for sig in "${sigs[@]}";
    do
	    local stack_name="$(trap_stack_name "$sig")"
	    local old_trap="$(get_trap "$sig")"
        
	    # eval '__trap_stack_SIGUSR1[${#__trap_stack_SIGUSR1[@]}]=$old_trap'
	    # __trap_stack_SIGUSR1[${#__trap_stack_SIGUSR1[@]}]=one
	    # trap two SIGUSR1
        
	    eval "${stack_name}"'[${#'"${stack_name}"'[@]}]=$old_trap'
	    trap "${new_trap}" "$sig"
    done
    return
}

## -----------------------------------------------------------------------
## Intent: Restore the last signal handler pushed
## -----------------------------------------------------------------------
trap_pop()
{
    local sigs=$*
    for sig in $sigs; do
	    local stack_name=`trap_stack_name "$sig"`
	    local count; eval 'count=${#'"${stack_name}"'[@]}'
	    [[ $count -lt 1 ]] && return 127
	    local new_trap
	    local ref="${stack_name}"'[${#'"${stack_name}"'[@]}-1]'
	    local cmd='new_trap=${'"$ref}"; eval $cmd
	    trap "${new_trap}" "$sig"
	    eval "unset $ref"
    done
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
trap_prepend()
{
    local new_trap=$1
    shift
    local sigs=$*
    for sig in $sigs; do
	    if [[ -z $(get_trap $sig) ]]; then
	        trap_push "$new_trap" "$sig"
	    else
	        trap_push "$new_trap ; $(get_trap $sig)" "$sig"
	    fi
    done
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
trap_append()
{
    local new_trap=$1
    shift
    local sigs=$*
    for sig in $sigs; do
	    if [[ -z $(get_trap $sig) ]]; then
	        trap_push "$new_trap" "$sig"
	    else
	        trap_push "$(get_trap $sig) ; $new_trap" "$sig"
	    fi
    done
}

: # NOP

# -----------------------------------------------------------------------
# [SEE ALSO]
# -----------------------------------------------------------------------
# https://stackoverflow.com/questions/16115144/bash-save-and-restore-trap-state-easy-way-to-manage-multiple-handlers-for-trap
# -----------------------------------------------------------------------

# [EOF]
