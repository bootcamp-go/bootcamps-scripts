#!/bin/sh

# Rename git tag to match the version

git tag $1 $2
git tag -d $1
git push origin $2 :$1