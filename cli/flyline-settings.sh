#~command failed (exit 1)> z edpl Flyline configuration — sourced from .bashrc after `enable -f ... flyline`.
# Kept separate from .bashrc so the trial can be abandoned by removing one
# source line, without touching the rest of the bash config.

# flyline isn't loaded in non-interactive shells (scripts, `bash -c`), so guard
# against that instead of erroring out every time something sources .bashrc.
if ! type flyline >/dev/null 2>&1; then
  return 0 2>/dev/null || exit 0
fi

# Cursor styling (flyline's rough equivalent of the zsh zle vi-mode cursor swap,
# though flyline has no modal vi editing — this is just static/animated styling)
flyline set-cursor --backend flyline --style "#33ccff" --effect fade

# Color palette. These mirror flyline's built-in `dark` theme defaults
# (src/palette.rs Palette::dark()) written out explicitly, one line per
# style, so any single slot can be tweaked without affecting the rest.
flyline set-style recognised-command="green"
flyline set-style unrecognised-command="red"
flyline set-style single-quoted-text="yellow"
flyline set-style double-quoted-text="magenta"
flyline set-style secondary-text="#666666"
flyline set-style inline-suggestion="italic blue"
flyline set-style tutorial-hint="bold"
flyline set-style matching-char="bold underline green"
flyline set-style opening-and-closing-pair="bold underline red"
flyline set-style normal-text="none"
flyline set-style comment="italic red"
flyline set-style env-var="cyan"
flyline set-style unrecognised-env-var="red"
flyline set-style markdown-heading1="bold cyan"
flyline set-style markdown-heading2="bold red"
flyline set-style markdown-heading3="bold magenta"
flyline set-style markdown-code="dim"
flyline set-style key-sequence-style="dim"
flyline set-style selected-text="white on #ff9898"
flyline set-style bash-reserved="bold yellow"
flyline set-style right-click-menu="black on #CCCCCC"
flyline set-style rainbow-bracket1="#ffd700"
flyline set-style rainbow-bracket2="#ff6464"
flyline set-style rainbow-bracket3="#64c8ff"
flyline set-style rainbow-bracket4="#64e696"
flyline set-style highlight="black on #CCCCCC"
# Tab completion / suggestions
flyline suggestions --auto-suggest true
flyline suggestions set-fuzzy-mode all

# Final (transient) prompt. The live PS1 stays full starship (dir, git branch,
# language versions, etc.) — only the collapsed scrollback line is simplified.
# Left side: just the dir and git branch (bold cyan / yellow, matching
# starship's colors) followed by `>`. Right side: how long the previous
# command took and when it happened, instead of cluttering every live prompt.
flyline create-prompt-widget custom --name FLYLINE_GIT_BRANCH_FINAL --command "$DOTFILES_DIR/cli/flyline-git-branch.sh" --block 150 --placeholder prev
# Final (transient) prompt styling. The whole line reads as "dimmed": a subtle
# dark-gray background (256-color 236) plus faint text, keeping the cyan/yellow/
# green hues but muted. Codes are combined per SGR (48;5;236 = bg, 2 = faint,
# then the fg colour) and \e[39m resets only the foreground so the background
# carries across the whole line.
#
# NOTE: the underscore fill between the left and right prompt (PS1_FILL_FINAL)
# does NOT render on the transient line with the current flyline build — its
# renderer hardcodes a blank fill on a prompt's last line (see app/ui.rs, the
# `is_last` branch of write_tagged_line_lrjustified). Until that is patched to
# honour the fill span when the prompt isn't running, the center gap stays
# unshaded; the styling below is already correct for when it is.
PS1_FINAL='\e[48;5;236;2;36m\W\e[39mFLYLINE_GIT_BRANCH_FINAL\e[48;5;236;2;37m> \e[0m'
PS1_FILL_FINAL='\e[48;5;236;2;38;5;240m '
flyline create-prompt-widget last-command-duration
RPS1_FINAL='\e[48;5;236;2;32mtook FLYLINE_LAST_COMMAND_DURATION\e[39m \e[34mat \D{%H:%M:%S}\e[0m'

# Pull zsh history into flyline's fuzzy search. This is a per-session runtime
# flag (grouped with --show-animations/--set-frame-rate etc. in `flyline --help`,
# not the persistent set-*/create-* subcommands), NOT a one-time import — it has
# to run on every shell startup or that session's Ctrl+R won't see zsh history.
flyline --load-zsh-history ~/.zsh_history

# Revert path if flyline's native history search isn't enough:
#   eval "$(atuin init bash)"

# flyline key bind Enter always=submitOrNewline   # example, tune later
# flyline set-agent-mode ...                       # see flyline examples/agent_mode.sh, decide later
#
flyline set-agent-mode \
    --system-prompt "Be concise. Answer with a JSON array of at most 3 items with objects containing: command and description. Command will be a Bash command." \
    --trigger-prefix ': ' \
    --command 'claude --effort low --print'
