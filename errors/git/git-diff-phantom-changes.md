# Git shows phantom file modifications (line endings)

> modified: file.txt

## What happened
`git status` shows files as modified even though you have not changed their content. The diff shows every line changed.

## Why it happens
This is caused by line ending differences between CRLF (Windows, `\r\n`) and LF (Unix/macOS, `\n`). When `core.autocrlf` is misconfigured, Git converts line endings on checkout, then detects the converted file as modified. This is especially common in cross-platform teams where Windows and macOS/Linux developers share a repository.

## How to fix it

Create or update `.gitattributes` in the repository root to enforce consistent line endings:
```bash
# .gitattributes
* text=auto eol=lf
*.bat text eol=crlf
*.cmd text eol=crlf
*.ps1 text eol=crlf
```

Then renormalize the repository:
```bash
git add --renormalize .
git commit -m "Normalize line endings"
```

Configure Git to handle line endings properly:
```bash
# On macOS/Linux - do not convert on checkout, convert CRLF to LF on commit
git config --global core.autocrlf input

# On Windows - convert to CRLF on checkout, convert to LF on commit
git config --global core.autocrlf true
```

If you just want to reset the current phantom changes:
```bash
git rm --cached -r .
git reset --hard
```

## Still not working?
- Check the current `autocrlf` setting: `git config --global core.autocrlf`.
- Verify with `file` command: `file file.txt` will show "ASCII text, with CRLF line terminators" if it has Windows endings.
- The `.gitattributes` file takes precedence over `core.autocrlf`, so use `.gitattributes` for consistent behavior across all developers.
- If specific binary files are being treated as text, mark them in `.gitattributes`: `*.png binary`.
