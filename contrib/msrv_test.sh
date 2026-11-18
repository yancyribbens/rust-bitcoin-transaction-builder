#!/bin/sh
#
# CI script for testing the MSRV of the `transaction builder`.
MSRV_MINOR_VERSION=56

# -e (errexit) will immediately exit on script fail.
# -x (xtrace) enable execution tracing with expanded variables and arguments.
set -ex

FEATURES="arbitrary"

# Sanity checks.
cargo --version
rustc --version

# set the Cargo.toml msrv dependencies
cp Cargo.msrv.toml Cargo.toml
cp Cargo.msrv.lock Cargo.lock

rustc=$(rustc --version | awk '{print $2}'| cut -d '.' -f 2)
if [ "$rustc" != "$MSRV_MINOR_VERSION" ]; then
	echo "current rustc toolchain is not the MSRV toolchain" >&2
	exit 1
fi

toml_msrv=$(grep -E '^rust-version =' Cargo.toml | cut -d '=' -f 2- | cut -d '.' -f 2)
if [ "$toml_msrv" != "$MSRV_MINOR_VERSION" ]; then
	echo "current toml rust-version is not the MSRV version" >&2
	exit 1
fi

if [ "$DO_FEATURE_MATRIX" = true ]; then
    # No features.
    cargo build --no-default-features
    cargo test --no-default-features

    # Single features.
fi

cargo build --all-features
# arbtest not available for MSRV cargo test
