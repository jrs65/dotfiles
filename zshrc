# History configuration
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt share_history extendedglob

export CLICOLOR=1

# Completion options
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

ZSH_PLUGINS=~/.dotfiles/zsh
source ${ZSH_PLUGINS}/history-substring-search/zsh-history-substring-search.zsh
source ${ZSH_PLUGINS}/fsh/fast-syntax-highlighting.plugin.zsh
source ${ZSH_PLUGINS}/autosuggestions/zsh-autosuggestions.zsh

# Install theme. Note that p10k has a minimum version requirement so we switch themes on older versions of zsh
if [[ $ZSH_VERSION < 5.2.0 ]]; then
    echo "ZSH version too old for theme."
    source ${ZSH_PLUGINS}/aphrodite-theme/aphrodite.zsh-theme
else
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    source ${ZSH_PLUGINS}/p10k/powerlevel10k.zsh-theme
    [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
fi


# Vim like editing
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

bindkey '^k' vi-cmd-mode # <C-k> for going to command mode

bindkey -M vicmd ' ' execute-named-cmd # Space for command line mode

# Home key variants
bindkey '\e[1~' vi-beginning-of-line
bindkey '\eOH' vi-beginning-of-line

# End key variants
bindkey '\e[4~' vi-end-of-line
bindkey '\eOF' vi-end-of-line

bindkey -M viins '^o' vi-backward-kill-word

bindkey -M vicmd 'yy' vi-yank-whole-line
bindkey -M vicmd 'Y' vi-yank-eol

bindkey -M vicmd 'y.' vi-yank-whole-line
bindkey -M vicmd 'c.' vi-change-whole-line
bindkey -M vicmd 'd.' kill-whole-line

bindkey -M vicmd 'u' undo
bindkey -M vicmd 'U' redo

bindkey -M vicmd 'H' run-help
bindkey -M viins '\eh' run-help

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Search with arrow keys, and Ctrl-p/n
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

bindkey -M vicmd '\-' vi-repeat-find
bindkey -M vicmd '_' vi-rev-repeat-find

bindkey -M viins '\e.' insert-last-word
bindkey -M vicmd '\e.' insert-last-word

bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line

# Fix up weird default backspace behaviour
bindkey -v '^?' backward-delete-char 


HOSTNAME=$(hostname -s)
ZSHRC_LOCAL="~/.zshrc-local"

if [[ -f ${~ZSHRC_LOCAL} ]]; then
    source ${~ZSHRC_LOCAL}
fi

if (( $+commands[nvim] )) ; then
	alias vim=nvim
	export EDITOR=nvim
else
	export EDITOR=vim
fi

