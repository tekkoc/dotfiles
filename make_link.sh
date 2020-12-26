#!/bin/sh

if [ ! -e ~/.config ] ; then
  mkdir ~/.config
fi

if [ ! -e ~/.config/fish ] ; then
  mkdir ~/.config/fish
fi

if [ ! -e ~/.hammerspoon ] ; then
  mkdir ~/.hammerspoon
fi

ln -sf `pwd`/fishrc ~/.config/fish/config.fish
ln -sf `pwd`/tmux.conf ~/.tmux.conf

ln -sf `pwd`/gitconfig ~/.gitconfig

ln -sf `pwd`/karabiner-elements.json ~/.config/karabiner/assets/complex_modifications/1984.json

ln -sf `pwd`/hammerspoon.lua ~/.hammerspoon/init.lua
