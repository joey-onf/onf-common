# -*- sh -*-
###########################################################################
## Usage:  source common.sh --tempdir --traputils
###########################################################################

# __DEBUG_COMMON__=1
[[ -v __DEBUG_COMMON__ ]] && echo " ** ${BASH_SOURCE[0]}: BEGIN"

source "${BASH_SOURCE[0]%/*}/common.sh" '--common-args-begin--'

[[ -v __DEBUG_COMMON__ ]] && echo " ** ${BASH_SOURCE[0]}: END"
: # NOP

# [EOF]

