---
description: Refresh data and findings for existing research using swarm orchestration
version: 0.5.0
argument-hint: "[--topic <slug>] [--area <area>] [--since <date>] [--no-delta] [--dimensions <dim1,dim2,...>]"
allowed-tools: Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion, WebFetch, WebSearch
---

Load and execute the sigint:update skill.

$ARGUMENTS are passed through to the skill.

Begin the update now based on: $ARGUMENTS
