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
cd dotfiles/.local/ && ./link-bins

GIT_FOLDER=$WORKSPACE_HOME/dists

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb && sudo dpkg -i ripgrep_12.1.1_amd64.deb

cd ~ && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cd ~/.oh-my-zsh && git apply $GIT_FOLDER/dotfiles/.configs/zsh/agn.patch

cd ~/.config
ln -s $GIT_FOLDER/dotfiles/.configs/git git
ln -s $GIT_FOLDER/dotfiles/.configs/zsh zsh
ln -s $GIT_FOLDER/dotfiles/.configs/vim vim
ln -s $GIT_FOLDER/dotfiles/.configs/xs xs

pip3 install nbstripout
/home/$USER/.local/bin/nbstripout --install --global

cd $GIT_FOLDER/dotfiles/.configs/zsh/ && ./completer

vim +PlugInstall +qall  > /dev/null

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

cd $GIT_FOLDER/ && git clone https://github.com/clvv/fasd
cd fasd && PREFIX=$HOME/.local make install

pip3 install -r /tmp/requirements.txt
PATH=~/.local/bin:$PATH && cd $GIT_FOLDER/dotfiles/.configs/ml && ./jupyterlab_extensions_setup && \
cd $GIT_FOLDER/dotfiles/.local/bin/ && ./jl

rm ~/.bashrc ~/.zshrc ~/.fzf.zsh ~/.fzf.bash

echo "bakery is installed"


