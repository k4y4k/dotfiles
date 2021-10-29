set TERM tmux-256color
set GOPATH /home/kayak/go

set -Ux tide_pwd_truncate_margin 9999

set -Ux EDITOR nvim

set -Ux ANDROID_HOME /home/kayak/android-sdk
set -Ux ANDROID_NDK_ROOT /home/kayak/android-ndk

set -Ux GTK_IM_MODULE fcitx
set -Ux QT_IM_MODULE fcitx
set -Ux XMODIFIERS @im=fcitx

set PATH $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $PATH

set PATH ~/.npm-global/bin /home/kayak/.local/bin /home/kayak/bin $PATH

set PATH ~/.cargo/bin $GOPATH/bin $PATH
# fix ruby
set PATH $PATH (ruby -e 'puts Gem.user_dir')/bin

alias yi="yay -Syu --combinedupgrade --noconfirm --sudoloop && yay -S --noconfirm --rebuild visual-studio-code-insiders-bin"
alias yr="yay -Rs --noconfirm --sudoloop"
alias work-here="subl . && smerge ."
alias lss="exa -a --grid --long"
alias zz="dunstctl close-all"

# [z]ettelkästen i[d]
alias zd="date +'%Y%m%d%H%M'"

# Update nVIM
alias uvim="nvim -c 'PlugClean!|PlugUpdate|PlugInstall|qa'"

# remake Spellfile for n/VIM
alias svim="nvim -c 'mkspell! ~/en.utf-8.add'"

# [p]ush to [a]ll remotes
alias pa='git remote | xargs -L1 git push --all'

# what now?
alias what-now="task what"

function zeal-docs-fix
    pushd "$HOME/.local/share/Zeal/Zeal/docsets" >/dev/null || return
    find . -iname 'react-main*.js' -exec rm '{}' \;
    popd >/dev/null || exit
end

. "$HOME/.homesick/repos/homeshick/homeshick.fish"
source "$HOME/.homesick/repos/homeshick/completions/homeshick.fish"

homeshick --quiet refresh 2

export QT_QPA_PLATFORMTHEME=qt5ct

function np #[n]vim-[p]rettier
    # get full path + filename (passed in as argument)
    set EDITING $argv
    # extract dir from full path
    set EDITINGPATH (dirname $argv)

    # after finishing up in nvim, run prettier on the dir
    nvim -p $argv && prettier --write $EDITINGPATH/*.*
end

function st #[s]tart [t]ask
    set TASK $argv
    task start $TASK
    task $TASK | grep -i "github url"
    task $TASK | grep -i "trello url"
end

alias stop="task +ACTIVE stop; timew stop"

# config.fish
if not pgrep --full ssh-agent | string collect > /dev/null
  eval (ssh-agent -c)
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

