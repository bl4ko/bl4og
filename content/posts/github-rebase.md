---
title: "Github rebase and merge issue"
date: "2023-10-24"
author: bl4ko
description: "In this post we will describe the weird behavior of Github's default rebase and merge strategy."
slug: github-rebase-issue
tags:
- git
- github
- rebase
autonumbering: true
draft: false
---

## Introduction

While working on one of my projects hosted on GitHub, I aimed to create a [linear history](https://www.bitsnbites.eu/a-tidy-linear-git-history/) using the [`git-rebase`](https://git-scm.com/docs/git-rebase) CLI tool. However, upon utilizing GitHub's built-in rebase and merge feature, I encountered two significant problems:

- Commits lost its **Verified** badge, indicating that the GPG signature was missing.
- The development branch **diverged** from the main branch, showing as **N commits ahead, M commits behind main**.

Upon investigating, I discovered this behavior is a well known issue with GitHub:

- [discussion1](https://github.com/orgs/community/discussions/4618#discussion-3458000)
- [discussion2](https://github.com/orgs/community/discussions/5524#discussion-3561504)
- [stackoverflow](https://stackoverflow.com/questions/60597400/how-to-do-a-fast-forward-merge-on-github/65314973#65314973)
- [issuecomment](https://github.com/isaacs/github/issues/1143#issuecomment-650219007)
- [official docs explanation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges#rebase-and-merge-your-commits)

Basically the reason is that the **rebase and merge behavior** on GitHub is different from native `git rebase`. Rebase and merge on GitHub will always update the committer information and create new [commit SHAs](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/about-commits#about-commits), whereas `git rebase` outside of GitHub does not change the committer information when the rebase happens on top of an ancestor commit.

## Issue Reproduction

Let's delve into a step-by-step reproduction of this issue, contrasting **local rebase** with **GitHub's rebase**.

### Local rebase

First, we'll establish a new git repository with two branches: `main` (default) and `develop`:

```bash
git init
echo "# Init commit" > README.md
git add README.md
git commit -m "Init commit"
```

Now we create **develop** branch, on which we add two new commits:

```bash
git checkout -b develop
echo "First change" > first.txt
git add first.txt
git commit -m "First new change"
echo "Second change" > second.txt
git add second.txt
git commit -m "Second new change"
```

Now, our develop branch will look like this:
  
```txt
# A,B,C are the hashes of the first 3 commits
A -> B -> C
```

We now perform rebase and merge our develop branch to main:

```bash
git rebase main
git checkout main
git merge develop
```

The main branch now looks as expected (same hashes as develop):

```txt
A -> B -> C
```

### GitHub rebase

For a different perspective, let's use GitHub's rebase and merge button:

```bash
# Create a new test github repo
# On the main branch
git remote add origin <new repo URL>
git push origin main
# Checkout to the develop branch and create 2 new commits
git checkout develop
echo "First addition" > add1.txt
git add add1.txt
git commit -m "First addition"
echo "Second addition" > add2.txt
git add add2.txt
git commit -m "Second addition"
git push origin develop
git rebase main # Rebase to main branch
```

Now locally on develop branch our git history will look like this:

```txt
A -> B -> C -> D -> E
```

Now instead of merging to main branch via CLI, we open a PR in GitHub's UI (Create a pull request base: main ← compare: develop). And merge it via **Rebase and merge** button:

![github-rebase-button](/github-rebase-button.png)

But now we can see that new commits SHA on main branch are different from on the develop branch:

```txt
MAIN:    A -> B -> C -> D'-> E'
DEVELOP: A -> B -> C -> D -> E
```

This comparison highlights GitHub's deviation from the default rebase and merge strategy,
where it recalculates the commit hashes, leading to the observed discrepancies.

## Solution

### CLI

Until the GitHub doesn't add a native "rebase and merge" option to its UI, the solution ([also recommended in docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#signature-verification-for-rebase-and-merge)) is to use CLI for merging:

- We can still open PR on the GitHub's UI to preserve workflows and team communication. But when PR is ready for merging, instead of clicking the **button for Rebase and merge**, we perform merging via CLI:

    ```bash
    # Example PR from development -> main
    git checkout main
    git merge development
    git push origin main
    ```

- Now, the SHA values for commits are preserved and so are GPG signatures.

### GitHub's fast-forward action

Another possible option is to use GitHub's [Fast Forward PR action](https://github.com/marketplace/actions/fast-forward-pr).
