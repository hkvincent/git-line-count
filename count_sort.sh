#!/bin/bash

# Assign command line arguments to variables
since=${1:-"2023-01-01"}
until=${2:-"2023-12-31"}
shift 2

# Declare an associative array to store results
declare -A results

# Loop over all remaining arguments as members
for member in "$@"
do
  # Get git log stats for the member
  stats=$(git log --author="$member" --since="$since" --until="$until" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s,%s,%s", add, subs, loc }')

  # Store the stats in the results array with the member as the key
  results["$member"]=$stats
done

# Print the results sorted by total lines
for member in "${!results[@]}"
do
  # Split the stats into an array
  IFS=',' read -ra stats <<< "${results[$member]}"

  # Print the stats with total lines first for sorting
  echo "${stats[2]} Total lines, Added lines: ${stats[0]}, Removed lines: ${stats[1]}, Member: $member"
done | sort -n -r
