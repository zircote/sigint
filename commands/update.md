---
description: Refresh data and findings for existing research using swarm orchestration
version: 0.5.0
argument-hint: "[--topic <slug>] [--area <area>] [--since <date>] [--no-delta] [--dimensions <dim1,dim2,...>]"
allowed-tools: Read, Write, Edit, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion, mcp__atlatl__capture_memory, mcp__atlatl__recall_memories, mcp__atlatl__enrich_memory, mcp__atlatl__blackboard_create, mcp__atlatl__blackboard_write, mcp__atlatl__blackboard_read, mcp__atlatl__blackboard_alert, mcp__atlatl__blackboard_pending_alerts, mcp__atlatl__blackboard_ack_alert
---

Load and execute the sigint:update skill.

$ARGUMENTS are passed through to the skill.

Begin the update now based on: $ARGUMENTS
