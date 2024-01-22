#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Common string functions
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Join a list of elements using delimiter
## -----------------------------------------------------------------------
## Given:
##   $1   Delimiter to join list on
##   $2+  A list of items to join
## -----------------------------------------------------------------------
## Usage;
##   readarray -t fields < <(awk -F: '{print $1}') /etc/passwd)
##   local val=$(join_by ':' "${fields[@]}")
##   declare -p val
## -----------------------------------------------------------------------
function join_by()
{
    local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; fi;
}

# [EOF]
