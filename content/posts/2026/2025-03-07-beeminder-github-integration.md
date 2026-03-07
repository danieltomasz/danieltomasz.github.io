---
title: "Tracking commits across multiple repositories with Beeminder"
date: 2026-03-07
tags: ["beeminder", "github", "productivity"]
draft: false
---

[Beeminder](https://www.beeminder.com/) is a habit-tracking tool built around committing to measurable progress over time. You can even put real money on the line, so missing your target comes with a financial sting — and for some people, that extra bit of accountability is surprisingly effective. It also integrates with various services, which makes it easy to track progress automatically instead of logging everything by hand. For programming, tracking habits like commits can help maintain momentum and make it easier to notice when you are quietly drifting away from a project.

Beeminder used to have an option to track commits across your whole GitHub account, but for new goals that is not really available anymore. The simple workaround is to create one **Do More** goal and let each repository send commit counts to it.

It sounds more complicated than it is. In practice, you create one Beeminder goal, add three secrets to each repository, and drop the same GitHub Actions workflow into all of them.

## Create a Do More goal

Create a normal **Do More** goal in Beeminder.

I used:

- goal slug: `github-commits`
- units: `commits`

Then go to Beeminder account settings and copy your API token from **Apps & API**.

## Add secrets to each repository

In every repository, go to:

`Settings -> Secrets and variables -> Actions -> New repository secret`

Add these three secrets:

- `BEEMINDER_USERNAME`
- `BEEMINDER_TOKEN`
- `BEEMINDER_GOAL`

For `BEEMINDER_GOAL`, use your goal slug, for example `github-commits`

## Add the workflow

Create `.github/workflows/beeminder-commits.yml` in each repository:

```yaml
name: Send commits to Beeminder

on:
  push:

jobs:
  beemind:
    runs-on: ubuntu-latest
    steps:
      - name: Send commit count to Beeminder
        env:
          BEEMINDER_USERNAME: ${{ secrets.BEEMINDER_USERNAME }}
          BEEMINDER_TOKEN: ${{ secrets.BEEMINDER_TOKEN }}
          BEEMINDER_GOAL: ${{ secrets.BEEMINDER_GOAL }}
          COMMITS_JSON: ${{ toJson(github.event.commits) }}
          REPO: ${{ github.repository }}
          SHA: ${{ github.sha }}
          REF: ${{ github.ref }}
        run: |
          count=$(python - <<'PY'
          import json, os
          data = os.environ.get("COMMITS_JSON", "[]")
          try:
              commits = json.loads(data)
              print(len(commits))
          except Exception:
              print(0)
          PY
          )

          if [ "$count" -eq 0 ]; then
            echo "No commits to send"
            exit 0
          fi

          curl -sS -X POST "https://www.beeminder.com/api/v1/users/${BEEMINDER_USERNAME}/goals/${BEEMINDER_GOAL}/datapoints.json" \
            -d "auth_token=${BEEMINDER_TOKEN}" \
            -d "value=${count}" \
            -d "comment=${REPO} ${REF} ${SHA}" \
            -d "requestid=${REPO}-${SHA}"
```

That is all the plumbing. Every time you push, GitHub Actions runs the workflow, counts the commits in that push, and sends that number to the same Beeminder goal.

## A small note

This counts commits in the push payload. For normal use that is fine. If you work across several repositories, this gives you one combined Beeminder graph without depending on the old GitHub integration.

If you only want to count pushes on `main`, change this:

```yaml
on:
  push:
    branches:
      - main
```

## Option 2: Count only your own commits

If you work in shared repositories, you may want to count only commits authored by you. In that case, you can filter commits by the email stored in your Git metadata. I have not battle-tested this setup yet in a repository with more active contributors, so treat it as a proposition of a workaround rather than something fully verified under shared-repo conditions.

```yaml
name: Send my commits to Beeminder

on:
  push:

jobs:
  beemind:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Send only my commit count to Beeminder
        env:
          AUTHOR_EMAIL: your.email@example.com
          BEFORE: ${{ github.event.before }}
          AFTER: ${{ github.event.after }}
          BEEMINDER_USERNAME: ${{ secrets.BEEMINDER_USERNAME }}
          BEEMINDER_TOKEN: ${{ secrets.BEEMINDER_TOKEN }}
          BEEMINDER_GOAL: ${{ secrets.BEEMINDER_GOAL }}
          REPO: ${{ github.repository }}
          SHA: ${{ github.sha }}
          REF: ${{ github.ref }}
        run: |
          count=$(git log --format='%ae' "${BEFORE}..${AFTER}" \
            | awk -v author="$AUTHOR_EMAIL" '$0 == author {c++} END {print c+0}')

          if [ "$count" -eq 0 ]; then
            echo "No matching authored commits to send"
            exit 0
          fi

          curl -sS -X POST "https://www.beeminder.com/api/v1/users/${BEEMINDER_USERNAME}/goals/${BEEMINDER_GOAL}/datapoints.json" \
            -d "auth_token=${BEEMINDER_TOKEN}" \
            -d "value=${count}" \
            -d "comment=${REPO} ${REF} ${SHA}" \
            -d "requestid=${REPO}-${SHA}"
```

To find the email you should put in `AUTHOR_EMAIL`, check the one Git actually uses in your commits rather than only the one stored in your general config. In a repository, you can run `git log -1 --format='%ae'` to print the author email from your most recent commit, which is usually the safest value to use here. You can also inspect your configured email with `git config user.email` for the current repository or `git config --global user.email` for your global Git setup.
