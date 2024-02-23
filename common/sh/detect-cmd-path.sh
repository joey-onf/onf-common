#-*- makefile -*-
## -----------------------------------------------------------------------
## Intent: Infer program path and ?-sandbox-? root directory
## -----------------------------------------------------------------------

[[ -v trace__detect_cmd_path ]] && { echo "** ENTER: ${BASH_SOURCE[0]##*/} (LINENO:$LINENO)"; }

if [[ ! -v pgmroot ]]; then
{
    declare -g pgm="$(readlink --canonicalize-existing "$0")"
    declare -g pgm_name="${pgm##*/}"

#   Use to detect lib subdir
#    local pgm_stem="${pgm_name%.*}"
#    declare -p pgm_stem

    declare -g pgmbin="${pgm%/*}"
    declare -g pgmroot="${pgmbin%/*}"

    readonly pgm    # pgm_abs
    readonly pgm_name
    readonly pgmbin
    readonly pgmroot
    # readonly pgmlib # ambiguous

    # [TODO] Support .anchor (parent-to-root) search
}
fi

[[ -v trace__detect_cmd_path ]] \
    && { echo "** LEAVE: ${BASH_SOURCE[0]##*/} (LINENO:$LINENO)"; } \
    || { true; }

:

# [EOF]
