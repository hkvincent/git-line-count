#!/bin/bash

# Assign the commit hash and optional file types to exclude from the parameters
commit_hash=$1
shift

# Initialize an array for the exclusion patterns
declare -a exclude_patterns=()

# Process each file type parameter to exclude
while [ -n "$1" ]; do
  # Add the exclusion pattern for the current parameter to the array
  exclude_patterns+=("*.$1")
  shift
done

# Get a list of all changes in the commit with stats
all_changes=$(git show --numstat --pretty="" $commit_hash)

# Declare an associative array to store results
declare -A results

# Read through each line of all_changes
while read -r add del file; do
  # Check if file matches any of the exclusion patterns
  for pattern in "${exclude_patterns[@]}"; do
    if [[ $file == $pattern ]]; then
      # Skip this file if it matches the exclusion pattern
      continue 2
    fi
  done

  # Get the author of the change for the current file in the commit
  author=$(git log -1 --format="%an" $commit_hash -- "$file")

  # Accumulate the stats in the results array for the author
  ((results["$author,add"]+=add))
  ((results["$author,del"]+=del))
done <<< "$all_changes"

# Print the results for each author
for key in "${!results[@]}"; do
  IFS=',' read -ra key_parts <<< "$key"
  author=${key_parts[0]}
  type=${key_parts[1]}

  if [ "$type" = "add" ]; then
    total=$((results["$author,add"] - results["$author,del"]))
    echo "${total} Total lines, Added lines: ${results[$author,add]}, Removed lines: ${results[$author,del]}, Member: $author"
  fi
done | sort -n -r
