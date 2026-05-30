#!/usr/bin/env bash
set -euo pipefail

make clean
make extract >/dev/null
BUILD_AND_VERIFY=1 QUIET=1 make

echo "BUILD SUCCEEDED. The rebuilt ROM matches snowboardkids.sha1."
