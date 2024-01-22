#!/usr/bin/env python3

"""Perform a recursive search for filesystem elements from pwd to root."""

# #-------------------##
# #---]  IMPORTS  [---##
# #-------------------##
import argparse
import os
import pprint
import sys
from contextlib import contextmanager
from pathlib import Path


@contextmanager
def pushd(path):

    """Closure: chdir with state retention.

    :param path: Target directory name
    :type  path: string

    :return  context with pwd=argument passed
    :rtype:
    """

    prev = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(prev)


def get_argv():
    """Parse command line options.

    :return   Script options passed on the command line
    :rtype:   argparse.ArgumentParser
    """

    parser = argparse.ArgumentParser(
        description = 'Search path toward root for file',
        epilog      = 'epilog text')

    parser.add_argument('--debug',
                        # action   = argparse.BooleanOptionalAction # --no-debug
                        action   = 'store_true',
                        default  = False,
                        help     = 'Enable debug mode',
                        )

    parser.add_argument('--dir',
                        type     = str,
                        default  = '.',
                        nargs    = '?',  # args: [0|1]
                        help     = 'Change directory before doing anything else')

    parser.add_argument('--sentinel',
                        metavar  = 'S',
                        required = True,
                        type     = str,
                        nargs    = '+', # list of patterns
                        default  = ['.find_to_root'],
                        help     = 'Element to search for in path')

    args = parser.parse_args()
    return args


def find_anchor_dir(args):

    """Search for a filesystem element by name.

    Given a sentinel file to search for traverse the filesystem toward root
    and return pathname of the containing directory.

    :param args: Parsed command line arguments
    :type  args: argparse.ArgumentParser()

    :return: A directory containing sentinel filesystem element.
    :rtype: string

    :Example:
    args = argparse.ArgumentParser()
    dir = find_anchor_dir(args)

    https://thomas-cokelaer.info/tutorials/sphinx/docstring_python.htmlhcd
    .. seealso::
    .. warnings::
    .. note::
    .. todo::
    """

    ans = None
    with pushd(args.dir):
        path = Path('.').resolve()
        # Safer than while not x.parent.as_posix == x.as_posix()
        dirs = path.parts
        for subdir in dirs:
            if not subdir: # pylint E0011
                continue
            if path.joinpath('.bashrc').exists():
                ans = path.as_posix()
                break
            path = path.parent

    return ans


# #----------------##
# #---]  MAIN  [---##
# #----------------##
def main():

    """Search for an anchor directory in the filesystem."""

    args = get_argv()
    if args.debug:
        pprint.pprint({
            'args'       : args,
            'args.dir'   : args.dir,
        })

    ans = find_anchor_dir(args)
    print(ans)
    if not ans:
        raise Exception("ERROR: find_to_root --sentinel not found")

    sys.exit(0)


if __name__ == "__main__":
    main()

# [SEE ALSO]
# -----------------------------------------------------------------------
# https://pathlib.readthedocs.io/en/0.5/
# https://docs.python.org/3/library/pathlib.html
# https://docs.python.org/3/library/argparse.html?highlight=argparse#module-argparse
# -----------------------------------------------------------------------

# [EOF]
