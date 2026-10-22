# review-load

A small CLI tool that shows **how many pending reviews each person has** on open PRs,
to help spread review requests more evenly across the team.

```
$ review-load
alice                  4
bob                    2
Herafia                1

$ review-load -m
Herafia — 1 review(s) en attente
  pluginsGLPI/pdf#95  Fix/46642/groups values in pdf  (@alice, 2026-10-01)
    https://github.com/pluginsGLPI/pdf/pull/95
```

## Installation

Requirements: [`gh`](https://cli.github.com/) authenticated (`gh auth login`) and `jq`.

```bash
gh api repos/Herafia/review-load/contents/install.sh -H 'Accept: application/vnd.github.raw' | bash
```

Running the same command again updates the tool.
`review-load` tells you when a newer version is available on GitHub.

## Usage

```bash
review-load                          # pending reviews count per team member (plugins)
review-load -m                       # my pending reviews, with a link to each PR
review-load -d                       # every team member's pending reviews, with links
review-load -o glpi                  # GLPI core (glpi-project/glpi repository)
review-load -o glpi -o plugins       # core + plugins
review-load -r glpi/glpi             # restricted to a single repository
review-load --drafts                 # include draft PRs
review-load -h                       # help
```

Shortcuts for `-o`: `glpi` = the `glpi-project/glpi` repository,
`plugins` = `pluginsGLPI` + `glpi-network`.
Any other organization can be passed by its full name (e.g. `-o teclib`).

## What is counted

- **Open** PRs (not merged, not closed), excluding drafts and archived repositories;
- **direct review requests that are still pending**: as soon as the person submits
  their review, the PR no longer counts for them.

## Your team

Each person has their own team list in `~/.config/review-load/team.txt`
(one GitHub login per line, `#` for comments). It is created on first install
with your own login, and is never overwritten by updates.

You can also point to another list with the `REVIEW_LOAD_TEAM` environment variable
or the `-t file` option. `review-load -m` does not need a team list.
