if whence hh >/dev/null 2>&1
then
  alias hh=hstr                    # hh to be alias for hstr
  export HSTR_CONFIG=hicolor       # get more colors
  export HISTFILE=~/.zsh_history   # ensure history file visibility
  bindkey -s "\C-r" "\eqhstr\n"    # bind hstr to Ctrl-r (for Vi mode check doc)
fi
