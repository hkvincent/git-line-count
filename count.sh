#!/bin/bash

# Assign command line arguments to variables
since=${1:-"2023-01-01"}
until=${2:-"2023-12-31"}
shift 2

# Loop over all remaining arguments as members
for member in "$@"
do
  echo "Stats for $member:"
  git log --author="$member" --since="$since" --until="$until" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "Added lines: %s, Removed lines: %s, Total lines: %s\n", add, subs, loc }'
done
