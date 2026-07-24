# Working in this repo (Jason's dotfiles)

## ⚠️ `zshrc.zsh` is immutable — unlock before editing

`~/.zshrc` is a symlink to `zshrc.zsh` in this repo, and the real file is
protected with the macOS immutable flag (`chflags uchg`) to stop third-party
installers from appending `export PATH=...` / `export NODE_EXTRA_CA_CERTS=...`
lines as if they own it.

**That flag also blocks *your* edits (and mine).** If a `Write`/`Edit`/`>>` to
`zshrc.zsh` fails with `operation not permitted`, it's the flag, not a bug.

### To edit `zshrc.zsh`

```zsh
chflags nouchg ~/dotfiles/zshrc.zsh   # unlock
# ... make the edit ...
chflags uchg   ~/dotfiles/zshrc.zsh   # re-lock (don't skip this!)
```

`zshrc-heal` (see below) toggles the flag around its own rewrite automatically,
so you only need to do this for manual edits.

### Don't add config to the bottom of `zshrc.zsh`

The file ends with a sentinel line:

```
### END OF ZSHRC — DO NOT APPEND ###
```

Nothing should live below it. A shell-start check warns if something does. New
config goes to its proper home instead:

| What you're adding                     | Where it goes                          |
| -------------------------------------- | -------------------------------------- |
| A directory for `$PATH`                | a `*.path` file in `path.d/`, or `path_add /dir` |
| An environment variable                | `env.zsh`                              |
| A shell function                       | `functions.zsh`                        |
| An alias                               | `aliases.zsh`                          |

`env.zsh` is sourced **last** and `path.zsh` dedups after all sourcing, so
values set there win over anything a tool injected earlier.

## Recovering from an injected `~/.zshrc`

If a tool got a write through (e.g. the flag was off) and appended below the
sentinel, two helpers in `functions.zsh` handle it:

- `zshrc-check` — show what was appended below the sentinel.
- `zshrc-heal`  — relocate injected lines (PATH dirs → `path.d/injected.path`,
  env exports → `env.zsh`, `NODE_EXTRA_CA_CERTS` dropped since `env.zsh` already
  pins it), then truncate the file back to the sentinel and re-lock.

## Other conventions

- **`$PATH` has one source of truth:** `path.zsh` + `path.d/`. Never add raw
  `export PATH=...` lines to `zshrc.zsh`. See the header of `path.zsh`.
- **`NODE_EXTRA_CA_CERTS` is pinned** in `env.zsh` to a single bundle so
  individual apps can't hijack it by pointing it at their own cert.
- **Symlinks are wired by `install.zsh`** (`link_dotfiles`), which also applies
  the immutable flag — so a fresh clone gets the protection automatically.
