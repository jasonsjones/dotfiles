# Path to your oh-my-zsh installation.
export ZSH=/Users/jasonjones/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# if [[ $TERM_PROGRAM != "WarpTerminal" && -d $ZSH/custom/themes/spaceship-prompt ]]; then
#     ZSH_THEME="spaceship"
# fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# NOTE: zsh-syntax-highlighting needs to be the last plugin loaded because of how it hooks into
# the zsh line editor (ZLE)
plugins=(git gitfast node yarn vi-mode z zsh-autosuggestions zsh-syntax-highlighting)

# User configuration

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Sourced here (rather than at the very end) because get_java_home is needed
# for the JAVA_HOME / PATH setup below.
source $HOME/dotfiles/functions.zsh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

if [[ -f "$HOME/.bootstrap_rc" ]]; then
    source /Users/jasonjones/.bootstrap_rc
fi

# ── PATH ──────────────────────────────────────────────────────────────────────
# All PATH logic lives in path.zsh. To add a new bin directory:
#   • Permanent (version-controlled): add a *.path file to ~/dotfiles/path.d/
#   • Permanent (personal/local):     run `path_add /some/dir`
#   • Current session only:           run `path_prepend /some/dir`
#
# NOTE: tools that auto-inject `export PATH=...` into this file should be moved
# to path.d/ and the injected lines removed. Run `path_show` to inspect.
source $HOME/dotfiles/path.zsh

# Deduplicate PATH after all sourcing (catches any tool-injected entries above)
typeset -U path

# ── ENV (sourced last so our values win over anything bootstrap_rc set) ───────
# env.zsh is also linked into $ZSH_CUSTOM so it loads for non-login shells,
# but re-sourcing here guarantees it overrides tool install scripts that
# clobber vars like NODE_EXTRA_CA_CERTS in .bootstrap_rc.
source $HOME/dotfiles/env.zsh

# --- LWR local-core build (Perforce stopgap) ---
# Perforce accounts are unavailable, so nucleus-core-packager can't fetch Core's
# pom via `p4 print`. The shim at ~/.local/bin/lwr-p4-shim feeds it a stub pom
# (real spring/utam versions) so the packager's pom step succeeds. The generated
# pom is unused by the override_repository flow, so this is safe.
# REMOVE the PATH prefix below once real p4 accounts are restored.
lwr-build() {
  PATH="$HOME/.local/bin/lwr-p4-shim:$PATH" yarn local-core:build "$@"
}
# --- end LWR local-core build ---

# ─── TAMPER SENTINEL — nothing should live below this line ──────────────────
# Third-party installers love to `echo 'export PATH=...' >> ~/.zshrc` (and the
# same for NODE_EXTRA_CA_CERTS). ~/.zshrc is chflags'd immutable to reject those
# writes outright, but if one slips through (e.g. after an intentional edit left
# the flag off), anything appended lands *below* this sentinel. This check warns
# at shell start so injected config is visible, not silent. To recover:
#   zshrc-check   # show what was injected below the sentinel
#   zshrc-heal    # relocate PATH→path.d/, env vars→env.zsh, truncate back
# ${(%):-%N} is the path of the current script (the symlink target).
if [[ "$(tail -1 ${(%):-%N} 2>/dev/null)" != *"### END OF ZSHRC — DO NOT APPEND ###"* ]]; then
    print -P "%F{yellow}⚠ ~/.zshrc: content was appended below the sentinel — run: zshrc-check%f"
fi
### END OF ZSHRC — DO NOT APPEND ###
