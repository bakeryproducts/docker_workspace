#!/bin/bash
set -e 

#mkdir -p .local
#mkdir -p .config

cd $WORKSPACE_HOME && mkdir dists 

cd $WORKSPACE_HOME/dists  
git clone https://github.com/bakeryproducts/shallow
cd shallow 
pip3 install -e .

cd $WORKSPACE_HOME/dists  
git clone https://github.com/bakeryproducts/shallow-run
cd shallow-run 
pip3 install -e .

cd $WORKSPACE_HOME/dists  
git clone https://github.com/bakeryproducts/dotfiles
cd dotfiles 


GIT_FOLDER=$WORKSPACE_HOME/dists

cd ~
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/.oh-my-zsh
git apply $GIT_FOLDER/dotfiles/.configs/zsh/agn.patch

cd ~/.config
ln -s $GIT_FOLDER/dotfiles/.configs/zsh zsh
ln -s $GIT_FOLDER/dotfiles/.configs/vim vim
ln -s $GIT_FOLDER/dotfiles/.configs/xs xs

cd $GIT_FOLDER/dotfiles/.configs/zsh/
./completer

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

cd $GIT_FOLDER/
git clone https://github.com/clvv/fasd
cd fasd
PREFIX=$HOME/.local make install

pip3 install -r /tmp/requirements.txt


echo "bakery is installed"