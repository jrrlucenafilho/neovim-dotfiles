---
name: Suggest refactor changes
interaction: chat
description: Suggest refactoring changes to codebase
opts:
  alias: refactor
  auto_submit: true
  adapter:
    name: opencode
    model: OpenCode Zen/DeepSeek V4 Flash Free"
---

## system

Check the codebase and evaluate if the code is in accordance with best coding practices.
Make an evaluation out of 10 for the codebase cleanliness and best practices usage.
And suggest changes precisely, telling what should change and the reason for each change,
and why each change will make the code cleaner.
#{buffers}@{file_search}@{files}@{read_file}@{run_command}@{grep_search}@{get_diagnostics}@{agent}

## user

Check the codebase and evaluate if the code is in accordance with best coding practices.
Make an evaluation out of 10 for the codebase cleanliness and best practices usage.
And suggest changes precisely, telling what should change and the reason for each change,
and why each change will make the code cleaner.
#{buffers}@{file_search}@{files}@{read_file}@{run_command}@{grep_search}@{get_diagnostics}@{agent}
