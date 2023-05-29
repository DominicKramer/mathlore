#!/usr/bin/env bash

# stop on first error
set -e

function latest_sha() {
  curl https://api.github.com/repos/mathlingua/${1}/commits/main | grep sha | head -1  | sed 's|"||g' | sed 's|sha:||g' | sed 's|,||g' | sed 's| ||g'
}

MATHLINGUA_SHA=$(latest_sha mathlingua)
MATHLORE_SHA=$(latest_sha mathlore-content)

sed -i '' "s|ARG MATHLINGUA_SHA=.*|ARG MATHLINGUA_SHA=${MATHLINGUA_SHA}|g" Dockerfile
sed -i '' "s|ARG MATHLORE_SHA=.*|ARG MATHLORE_SHA=${MATHLORE_SHA}|g" Dockerfile
