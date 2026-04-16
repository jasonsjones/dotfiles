# path.d — Drop-in PATH directory

Add a `*.path` file here instead of modifying `.zshrc` when a tool needs its
bin directory on `$PATH`.

## Format

Each file contains one directory path per line. The literal string `$HOME` is
expanded. Lines starting with `#` are comments and are ignored.

```
# My tool
$HOME/.mytool/bin
```

## Files

| File | Owner |
|---|---|
| `windsurf.path` | Windsurf / Codeium editor |
| `aisuite.path` | Salesforce AI Suite CLI |
| `custom.path` | Created by `path_add` for interactive additions |

## Helper commands (available in any shell)

```zsh
path_add /some/dir    # persist to custom.path + prepend now
path_show             # print PATH entries, numbered
path_prepend /dir     # prepend for current session only
path_append /dir      # append for current session only
```
