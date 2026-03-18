# Contributing

Got an error message that took you hours to figure out? Add it here so the next person doesn't suffer.

## Format

Every error file follows this structure:

```markdown
# Error Message

> The exact error message as it appears in the terminal/browser/logs

## What happened

1-2 sentences explaining what triggered this error in plain language.

## Why it happens

The actual root cause. Not "something went wrong", but the specific technical reason.

## How to fix it

```bash
# The actual commands or code changes that fix it
```

## Don't do this

Common "fixes" that make things worse or just hide the problem.

## Still not working?

Edge cases or less common causes of the same error.
```

## Rules

1. **One error per file** in `errors/<stack>/`
2. **Filename** is the error in lowercase kebab-case: `eacces-permission-denied.md`
3. **Include the exact error message** in a blockquote at the top
4. **Real fixes only.** Commands you've actually run and verified.
5. **Explain WHY**, not just what to type. People should understand the root cause.
6. **Include "Don't do this"** when there are common bad fixes (like `sudo npm install -g`)
7. **No AI-generated fluff.** If you haven't hit this error yourself, don't write about it.

## Steps

1. Fork the repo
2. Create `errors/<stack>/your-error.md`
3. Open a PR with the title: `add(<stack>): error description`
4. Bonus: add a link to the README table

## What makes a great error entry

- Written by someone who actually hit the error and spent time debugging it
- Includes the real root cause, not just "try this and hope"
- Has a "Don't do this" section that saves people from making it worse
- Mentions edge cases or variations of the same error
