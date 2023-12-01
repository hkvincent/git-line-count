# git-line-count
The script is used to count the lines of code per team member.

# How to use with non-sort
you can run the script with just the member names, and it will use the default date range:

```bash
./count.sh "John" "Vincent" "Joey" "Victor"
```

Or you can provide a custom date range:

```bash
./count.sh "2023-02-01" "2023-03-01" "John" "Vincent" "Joey" "Victor"
```
# How to use with sort
you can run the script with just the member names, and it will use the default date range:

```bash
./count_sort.sh "John" "Vincent" "Joey" "Victor"
```

Or you can provide a custom date range:

```bash
./count_sort.sh "2023-02-01" "2023-03-01" "John" "Vincent" "Joey" "Victor"
```

# How to use "sort" and ignore specific files.
```bash
./count_ignore.sh "2023-02-01" "2023-03-01" css scss -- "John" "Vincent" "Joey" "Victor"
```
# How to use for specified commit

```bash
./count_commit.sh java css -- [commithash1 commithash2] 
````

# How to use for specified branch
```bash
./count_branch.sh java css -- [branch name] 
````
