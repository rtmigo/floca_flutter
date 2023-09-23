#!/bin/bash
set -e && cd "${0%/*}"

cd ..
dart bin/floca.dart test/data/src.csv example/lib/generated_i18n.dart