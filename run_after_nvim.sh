#!/bin/fish

echo "removing chezmoi lazy lock"
rm -f $(chezmoi source-path)/dot_config/nvim/lazy-lock.json

echo "updating lazy"
# https://vi.stackexchange.com/questions/43972/lazy-nvim-upgrade-plugins-from-command-line
nvim --headless "+Lazy! sync" +qa

echo "moving new lazy lock back to state"
mv ~/.config/nvim/lazy-lock.json $(chezmoi source-path)/dot_config/nvim/lazy-lock.json

