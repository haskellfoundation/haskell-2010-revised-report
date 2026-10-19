# Contributing Guidelines

The Haskell report belongs to the entire Haskell community, and everyone is encouraged to contribute issues, PRs and to participate in the discussions. You don't have to be a member of a committee to meaningfully contribute to the next version of the report!

## Scope of the Project

In this iteration we are focusing exclusively on bringing the Haskell 2010 report up to date with how the language is implemented in compilers like GHC and MicroHS, and how the standard libraries are implemented in the base library.

Any additional language features that are not already part of Haskell 2010 are considered out of scope, and corresponding issues and PRs will be closed.

## Issues and PRs

Any major planned change to the report requires a corresponding issue in the issue tracker before a PR can be opened.
The rule of thumb is that a change is considered major if it will appear in the list of changes to the revised report.

We expect to see a lot of pull requests that fix minor issues with the report, such as typo fixes, layout improvements, minor improvements to the code and infrastructure etc.
These minor changes do not require a corresponding issue.

## Voting Procedure on Major Changes

Once a PR is ready for its final round of comments and votes we attach the label `process: vote-in-progress` to the PR. According to the bylaws of the Haskell Foundation working group which produces this report ([here](https://gitlab.haskell.org/hf/meta/-/blob/main/working_groups/revised-haskell-2010-report.md)) a change needs two thirds of the votes of the working group to be accepted. For 11 members this means that we attach the `process: accepted` tag to a PR as soon as 8 votes have been reached.

## Style Guide

Please adhere to the following styling rules when working on the text of the report.

### No Footnotes

Since we have to generate both the paged PDF version and the unpaged HTML version we do not use footnotes in the language report.
