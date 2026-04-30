#!/bin/bash
# Usage: ./build.sh [apk|ios|appbundle]
# Requires .env.json to exist in this directory
flutter build ${1:-apk} \
  --dart-define-from-file=.env.json \
  "$@"
