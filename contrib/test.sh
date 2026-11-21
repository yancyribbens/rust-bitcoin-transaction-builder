#!/bin/sh
#
# CI script for the `transaction builder` crate.

# -e (errexit) will immediately exit on script fail.
# -x (xtrace) enable execution tracing with expanded variables and arguments.
set -ex

FEATURES="arbitrary"

# Sanity checks.
cargo --version
rustc --version

cargo build --all-features
cargo test --all-features

if [ "$DO_FEATURE_MATRIX" = true ]; then
    # No features.
    cargo build --no-default-features
    cargo test --no-default-features

    # Single features.
    for feature in ${FEATURES}
    do
        cargo build --no-default-features --features="$feature"
        cargo test --no-default-features --features="$feature"
    done
fi

if [ "$DO_LINT" = true ]
then
    rustup component add clippy
    cargo clippy --all-features --all-targets -- -D warnings
fi
