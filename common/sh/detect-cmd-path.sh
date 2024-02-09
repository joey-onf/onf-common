#-*- makefile -*-
## -----------------------------------------------------------------------
## Intent: Infer program path and ?-sandbox-? root directory
## -----------------------------------------------------------------------

[[ -v trace__detect_cmd_path ]] && { echo "** ENTER: ${BASH_SOURCE[0]##*/} (LINENO:$LINENO)"; }

if [[ ! -v pgmroot ]]; then
{
	[[ -v debug__detect_cmd_path ]] && { local -i debug=1; }

    # Would like FUNCNAME[0] but we lack function context
	[[ -v debug ]] && { echo "** ENTER: ${BASH_SOURCE[0]##/*} (LINENO:$LINENO)"; }

    declare -g pgm="$(readlink --canonicalize-existing "$0")"
    readonly pgm

	declare -g pgm_name="${pgm##/*}"
    readonly pgm_name

    declare -g pgmbin="${pgm%/*}"
    declare -g pgmroot="${pgmbin%/*}"
    declare -g pgmlib="${pgmroot%/*}/onf_urls/onf_urls"
    readonly pgmbin
    readonly pgmroot
    readonly pgmlib

    # [TODO] Support .anchor (parent-to-root) search

	[[ -v debug ]] && { echo "** LEAVE: ${BASH_SOURCE[0]##/*} (LINENO:$LINENO)"; }
}
fi

[[ -v trace__detect_cmd_path ]] && { echo "** LEAVE: ${BASH_SOURCE[0]##*/} (LINENO:$LINENO)"; }

:

# [EOF]
