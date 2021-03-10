---
title: "Useful git commands"
date: 2021-01-30 
draft: false 
description: "Some commands I want to remember"
tags: 
 -  git
 -  tips
---

 I am adding  here some commands that were useful for me.

### Only add tracked files
```
git add -u
```

### Amend commit with new files

```
git add -u
git commit --amend --no-edit
git push --force
```
or 
```
git commit --amend --no-edit -a
```

to add the currently changed files.

## Keep fork up to date

```
cd  fork_folder/
git remote add upstream git://github.com/devname/orginal-repo.git
git remote -v
git fetch upstream
git checkout main
git merge upstream/main
```
## What is git rebase?

>Rebasing is the process of moving or combining a sequence of commits to a new base commit.

Don't rebase public history 

## Submodules

A submodule is a link to a repository within a Git repository.

```bash
git submodule add https://github.com/link
git submodule update --remote --recursive
```