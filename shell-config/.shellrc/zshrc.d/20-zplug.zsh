# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "junegunn/fzf-bin", \
    as:command, \
    from:gh-r, \
    rename-to:fzf
zplug "junegunn/fzf", use:shell/key-bindings.zsh
#zplug "changyuheng/zsh-interactive-cd"

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/symfony2", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh

#zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
#zplug "zsh-users/zsh-completions"

zplug "agnoster/agnoster-zsh-theme", from:github, as:theme

# Add a bunch more of your favorite packages!
source /usr/share/powerline/bindings/zsh/powerline.zsh
# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

if zplug check b4b4r07/enhancd; then
    # setting if enhancd is available
    export ENHANCD_FILTER=fzf-tmux
fi
