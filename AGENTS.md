# AGENTS.md

This project is a small ruby gem for building HTML tags.

## Commits

- All AI assisted commits should have a trailer: `Assisted-by: <model>`
- [Scoped commits](https://scopedcommits.com/), not conventional commits. Short version:

```
<scope>: <description>

[optional body]

[optional trailer(s)]
```

- <scope> — the subsystem, area, or module that the commit touches
- <description> — a short description of the changes made
- [optional body] — detailed information about the changes
- [optional trailer(s)] — additional metadata about the commit

## Agent skills

### Issue tracker

Issues live in GitHub Issues for `rbuchberger/objective_elements`, managed via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles, each using its default label string. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
