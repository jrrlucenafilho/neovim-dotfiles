---
name: Commit message in PTBR
interaction: chat
description: Git commit message in brazillian portuguese
opts:
  alias: commit-ptbr
  auto_submit: true
  adapter:
    name: gemini
    model: gemini-3.1-flash-lite-preview
---

## system

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:
Be sure to include the scope of the commit

## user

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:
Be sure to include the scope of the commit

```diff
${commit-ptbr.diff}
```
