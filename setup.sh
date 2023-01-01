#!/bin/sh

if [ ! -e ~/.config ] ; then
  mkdir ~/.config
fi

if [ ! -e ~/.config/fish ] ; then
  mkdir ~/.config/fish
fi

# if [ ! -e ~/.config/nvim ] ; then
#  mkdir ~/.config/nvim
# fi

if [ ! -e ~/.hammerspoon ] ; then
  mkdir ~/.hammerspoon
fi

ln -sf `pwd`/vimrc ~/.vimrc

ln -sf `pwd`/nvim ~/.config/nvim
# ln -sf `pwd`/nvimrc ~/.config/nvim/init.vim
# ln -sf `pwd`/nvim/coc-settings.json ~/.config/nvim/coc-settings.json

ln -sf `pwd`/fishrc ~/.config/fish/config.fish
ln -sf `pwd`/tmux.conf ~/.tmux.conf

ln -sf `pwd`/gitconfig ~/.gitconfig
ln -sf `pwd`/gitignore_global ~/.gitignore_global

if [ ! -e ~/.config/karabiner ] ; then
  ln -sf `pwd`/karabiner-elements.json ~/.config/karabiner/assets/complex_modifications/1984.json
fi

ln -sf `pwd`/hammerspoon.lua ~/.hammerspoon/init.lua

ln -sf `pwd`/xvimrc ~/.xvimrc
