## Shell TODO(s)

- shellcheck all sources using v0.9.0
- Verify POSIX signal handling else platform specific cases.

- stacktrace.sh

    - Add conditional debugging verbosity.
    - set +o xtrace

- tempdir.sh

    - also support mkstemp (replace as default?)
    - What to do with sigtrap to prevent over-writing ?

- traputils.sh

    - trap stack should become read-only after common.sh setup.
    - maintain a separate callback stack for program use.    