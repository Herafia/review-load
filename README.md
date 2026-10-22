# review-load

A small CLI tool that shows **how many pending reviews each person has** on open PRs,
to help spread review requests more evenly across the team.

```
MEMBRE                    REVIEWS EN ATTENTE
------------------------- ------------------
alice                       4  ####
bob                         2  ##
Herafia                     1  #

Total : 7 review(s) en attente
```

## Installation

Requirements: [`gh`](https://cli.github.com/) authenticated (`gh auth login`) and `jq`.

```bash
gh api repos/Herafia/review-load/contents/install.sh -H 'Accept: application/vnd.github.raw' | bash
```

Running the same command again updates the tool (including the team list).

## Usage

```bash
review-load -o glpi-project          # table per person
review-load -o glpi-project -d       # + list of each person's PRs
review-load -r glpi-project/glpi     # restricted to a single repository
review-load --drafts                 # include draft PRs
review-load -h                       # help
```

## What is counted

- **Open** PRs (not merged, not closed), excluding drafts and archived repositories;
- **direct review requests that are still pending**: as soon as the person submits
  their review, the PR no longer counts for them.

## The team

Team members are listed in [`team.txt`](team.txt) (one GitHub login per line).
To add someone: edit this file in the repository, then everyone re-runs the install command.

To use your own list: `~/.config/review-load/team.txt`, the `REVIEW_LOAD_TEAM`
environment variable, or the `-t file` option.
