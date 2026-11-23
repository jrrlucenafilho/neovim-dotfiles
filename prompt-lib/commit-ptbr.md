---
name: Commit message in PTBR
interaction: chat
description: Git commit message in brazillian portuguese
opts:
  alias: commit-ptbr
  auto_submit: true
  adapter:
    name: opencode
    model: deepseek/DeepSeek V4.1 Flash 1017
---

## system

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:
Be sure to include the scope of the commit.
Don't write any text or wrappers other than the commit message

## user

You are an expert at following the Conventional Commit specification.
Given the git diff listed below, please generate a commit message for me in Brazillian Portuguese:
Be sure to include the scope of the commit
Don't write any text or wrappers other than the commit message

```diff
${commit-ptbr.diff}
```
