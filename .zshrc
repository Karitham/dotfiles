source ~/.config/sh/rc

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent
eval "$(atuin init zsh)"
