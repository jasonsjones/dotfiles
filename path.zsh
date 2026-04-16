# path.zsh — canonical $PATH management
#
# This is the single source of truth for $PATH. Do not add raw
# `export PATH=...` lines to .zshrc. Instead:
#
#   • For paths you manage:     add a *.path file to ~/dotfiles/path.d/
#   • For the current session:  run `path_add /some/dir`
#   • To inspect the live PATH: run `path_show`
#
# zsh binds the $path array to $PATH; typeset -U enforces uniqueness so
# duplicates are silently dropped regardless of where they come from.
typeset -U path

# ── Helpers ───────────────────────────────────────────────────────────────────

# Add to the FRONT of PATH (highest priority). No-op if dir doesn't exist.
path_prepend() { [[ -d "$1" ]] && path=("$1" $path) }

# Add to the END of PATH (lowest priority). No-op if dir doesn't exist.
path_append()  { [[ -d "$1" ]] && path+=("$1") }

# Persist a path to path.d/custom.path and prepend it to the current session.
# Usage: path_add /path/to/bin
path_add() {
    local p="${1:?Usage: path_add /path/to/bin}"
    local d="${DOTFILES:-$HOME/dotfiles}/path.d"
    local f="$d/custom.path"
    mkdir -p "$d"
    if ! grep -qxF "$p" "$f" 2>/dev/null; then
        echo "$p" >> "$f"
        echo "Persisted '$p' → $f"
    fi
    path_prepend "$p"
}

# Print the current PATH, one entry per line, numbered.
path_show() { echo $PATH | tr ':' '\n' | cat -n }

# ── Architecture ──────────────────────────────────────────────────────────────

_IS_ARM64=false
[[ "$(uname -m)" == "arm64" ]] && _IS_ARM64=true

# ── Homebrew ──────────────────────────────────────────────────────────────────
# zprofile already runs `brew shellenv` for login shells. We set HOMEBREW_PREFIX
# here as a fallback (non-login shells) and ensure the bins are on PATH.

if $_IS_ARM64; then
    : "${HOMEBREW_PREFIX:=/opt/homebrew}"
else
    : "${HOMEBREW_PREFIX:=/usr/local}"
fi
path_prepend "$HOMEBREW_PREFIX/sbin"
path_prepend "$HOMEBREW_PREFIX/bin"

# ── Java ──────────────────────────────────────────────────────────────────────
# On Apple Silicon we use the Salesforce internal JDK if available;
# otherwise fall back to the system java_home on both arches.

if $_IS_ARM64; then
    # get_java_home is defined in functions.zsh (must be sourced before path.zsh)
    _jdk_dir="/opt/workspace/core-public/tools/Darwin/jdk/$(get_java_home 2>/dev/null)"
    [[ -d "$_jdk_dir" ]] && export JAVA_HOME="$_jdk_dir"
    unset _jdk_dir
fi

if [[ -z "$JAVA_HOME" && -x /usr/libexec/java_home ]]; then
    export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
fi
[[ -n "$JAVA_HOME" ]] && path_prepend "$JAVA_HOME/bin"

# ── Volta (Node.js version manager) ───────────────────────────────────────────
export VOLTA_HOME="$HOME/.volta"
path_prepend "$VOLTA_HOME/bin"

# ── Salesforce CORE workspace ─────────────────────────────────────────────────
# The CORE path differs between the Mac Studio (wsm) and the standard M-chip
# dev laptop; Intel machines don't use the internal JDK tree at all.

if $_IS_ARM64; then
    if [[ "$(hostname)" == *wsm* ]]; then
        export CORE="$HOME/projects/git-core/core-public"
    else
        export CORE="/opt/workspace/core-public"
    fi
fi

# ── Personal bin dirs ─────────────────────────────────────────────────────────
path_prepend "$HOME/blt"
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

# ── Drop-in paths (path.d/) ───────────────────────────────────────────────────
# Any *.path file in this directory is loaded automatically. Each file should
# contain one absolute directory path per line. Lines starting with # are
# ignored. The literal string $HOME is expanded.
#
# Prefer adding files here over editing .zshrc when a tool needs a bin dir on
# PATH (e.g. create path.d/mytool.path with the path inside).

_path_d="${DOTFILES:-$HOME/dotfiles}/path.d"
if [[ -d "$_path_d" ]]; then
    _f="" _p=""
    for _f in "$_path_d"/*.path(N); do
        while IFS= read -r _p || [[ -n "$_p" ]]; do
            [[ -z "$_p" || "$_p" == \#* ]] && continue
            _p="${_p/\$HOME/$HOME}"
            path_prepend "$_p"
        done < "$_f"
    done
    unset _f _p
fi
unset _path_d _IS_ARM64
