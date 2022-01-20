#!/bin/sh

# Rename git tag to match the version

git tag $2 $1
git tag -d $1
git push origin $2 :$1