#!/bin/bash

# Assign command line arguments to variables
since=${1:-"2023-01-01"}
until=${2:-"2023-12-31"}
shift 2

# Initialize an array for the exclusion patterns
declare -a exclude_patterns=()

# Process each ignore parameter
while [ -n "$1" ] && [[ "$1" != "--" ]]; do
  # Add the exclusion pattern for the current parameter to the array
  exclude_patterns+=(":!*$1")
  shift
done

# Skip the "--" separator
[ "$1" == "--" ] && shift

# Declare an associative array to store results
declare -A results

# Loop over all remaining arguments as members
for member in "$@"
do
  # Get git log stats, applying the exclusion patterns if provided
  if [ ${#exclude_patterns[@]} -ne 0 ]; then
    # Exclude specified file types
    stats=$(git log --author="$member" --since="$since" --until="$until" --pretty=tformat: --numstat -- "${exclude_patterns[@]}" | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s,%s,%s", add, subs, loc }')
  else
    # No exclusions, get git log stats normally
    stats=$(git log --author="$member" --since="$since" --until="$until" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s,%s,%s", add, subs, loc }')
  fi

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
