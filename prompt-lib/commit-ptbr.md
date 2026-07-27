---
name: Commit message in PTBR
interaction: chat
description: Git commit message in brazillian portuguese
opts:
  alias: commit-ptbr
  auto_submit: true
  adapter:
    name: ollama
    model: gemma4:31b-cloud
---

## system

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:
Be sure to include the scope of the commit.
Don't write any text other than the commit message

## user

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:
Be sure to include the scope of the commit
Don't write any text other than the commit message

```diff
${commit-ptbr.diff}
```
