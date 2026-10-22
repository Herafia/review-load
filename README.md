# review-load

A small CLI tool that shows **how many pending reviews each person has** on open PRs,
to help spread review requests more evenly across the team.

```
$ review-load
pseudo1                4
pseudo2                2
pseudo3                1

$ review-load -m
pseudo3 — 1 pending review(s)
  pluginsGLPI/example#42  Fix something important  (@pseudo1, 2026-10-01)
    https://github.com/pluginsGLPI/example/pull/42

$ review-load -p
My open PRs — 3
🔁 pluginsGLPI/example#43  Add a new feature                              2d    ✅ pseudo1  🔁 pseudo2  ⏳ pseudo3  CI ✅
🚀 pluginsGLPI/example#45  Fix a small bug                                0d    ✅ pseudo1  CI ✅
📝 pluginsGLPI/example#44  Work in progress                               12d   CI ❌  ⚠️ conflicts

🔁 changes requested  🚀 ready to merge  ✅ approved  👀 waiting for review  ❔ no reviewer  📝 draft
💬 commented  ⏳ pending  ↻ re-requested after requesting changes  Nd = days without activity
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
review-load -p                       # status of my own open PRs (see below)
review-load -a pseudo1 pseudo2       # add people to your team list
review-load -o glpi                  # GLPI core (glpi-project/glpi repository)
review-load -o glpi -o plugins       # core + plugins
review-load -r pluginsGLPI/fields    # restricted to a single repository
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

## Status of my PRs (`-p`)

`review-load -p` lists your own open PRs (drafts included), one line per PR, grouped by status:

- 🔁 changes requested
- 🚀 ready to merge: you have the right to merge it and GitHub would let you merge it now
- ✅ approved
- 👀 waiting for review
- ❔ no reviewer
- 📝 draft

Each line shows the number of days without activity, who approved, who requested changes,
who commented, whose review is still pending, the CI status and merge conflicts.
Your own reviews are ignored. A reviewer who requested changes and was asked again for
a review is shown as pending with `↻`: the PR is waiting on them, not on you.

The PR number is a clickable link in terminals that support it (GNOME Terminal, Konsole,
iTerm2, VS Code…). Same scope as the other modes (`-o`, `-r`, plugins by default).

## Your team

Each person has their own team list in `~/.config/review-load/team.txt`
(one GitHub login per line, `#` for comments). It is created on first install
with your own login, and is never overwritten by updates.

To add people, either edit the file or run:

```bash
review-load -a pseudo1 pseudo2
```

Each login is checked against GitHub (unknown accounts are rejected, the exact
spelling is fixed) and duplicates are ignored.

You can also point to another list with the `REVIEW_LOAD_TEAM` environment variable
or the `-t file` option. `review-load -m` does not need a team list.
