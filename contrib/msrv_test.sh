#!/bin/sh
#
# CI script for testing the MSRV of the `transaction builder`.

# -e (errexit) will immediately exit on script fail.
# -x (xtrace) enable execution tracing with expanded variables and arguments.
set -ex

# Sanity checks.
cargo --version
rustc --version

# set the Cargo.toml msrv dependencies
cp Cargo.msrv.toml Cargo.toml
cp Cargo.msrv.lock Cargo.lock

cargo build
# arbtest not available for MSRV cargo test
