

eval "$(/opt/homebrew/bin/brew shellenv)"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

fzf --fish | source

source /opt/homebrew/opt/asdf/libexec/asdf.fish

starship init fish | source

export ANDROID_WHEREABOUTS="/Volumes/Palm-Sized-Wondah/android"

export PATH="$ANDROID_WHEREABOUTS/sdk/emulator:$ANDROID_WHEREABOUTS/sdk/tools:$ANDROID_WHEREABOUTS/sdk:$ANDROID_WHEREABOUTS/sdk/platform-tools:$PATH"

# sets JAVA_HOME
. ~/.asdf/plugins/java/set-java-home.fish

export ANDROID_HOME="$ANDROID_WHEREABOUTS"

export PATH="$HOME/bin/:$PATH"
export PATH="$HOME/.bin/:$PATH"
