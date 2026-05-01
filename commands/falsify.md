---
description: Adversarially falsify research findings via web-only disconfirming search; quarantine, downgrade, or annotate findings based on verdicts
version: 0.1.0
argument-hint: "[--scope all|dimension:<dim>|finding:<id>] [--query-budget <n>] [--claim-budget <n>] [--mode block|advisory]"
allowed-tools: Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion, WebSearch, WebFetch
---

Load and execute the sigint:falsify skill.

$ARGUMENTS are passed through to the skill as-is.

Run adversarial falsification on the active research session now based on: $ARGUMENTS
