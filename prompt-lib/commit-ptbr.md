---
name: Comit message in PTBR
interaction: chat
description: Git commit message in brazillian portuguese
opts:
  alias: commit-ptbr
  auto_submit: true
  adapter:
    name: copilot
    model: claude-haiku-4.5
---

## system

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:

## user

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:

```diff
${commit-ptbr.diff}
```
