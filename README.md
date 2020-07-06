# .vim(Gvim on Win32 please see master-gui:README.md)

## Installation
1. Clone .vim:
*  git clone https://github.com/Shaiya2688/.vim ~/.vim

2. Install the latest version of VIM (support minimum version v8.2):
*  git clone https://github.com/vim/vim.git ~/.vim/vim
*  cd ~/.vim/vim/src
*  make distclean (if you build vim before)
*  ./configure --enable-fail-if-missing --with-features=huge --enable-pythoninterp=yes --enable-python3interp=yes --enable-cscope --enable-terminal (use './configure --help' for help if need)
*  make
*  ./vim --version (for features included(+) or not(-) check)
*  sudo make install

3. Setup vim-plug manager:
*  git clone https://github.com/junegunn/vim-plug ~/.vim/bundle/vim-plug

4. Install Plugins:
*  Launch vim and run :PluginInstall(keymap: < F10 >)

5. About Keymap Usage:
*  Launch vim and type < C-F1 > to show Keymap usage information

## Optional Installation
1. Setup the optional tools environment:
*  Source "envsetup.sh" in ~/.bashrc as below:
*  if [ -f ~/.vim/optional-tools/envsetup.sh ]; then
*    . ~/.vim/optional-tools/envsetup.sh
*  fi

2. LSP client and Language Servers environment setup
*  What is the Language Server Protocol? [website](https://microsoft.github.io/language-server-protocol)
*  LSP client and Language Servers [LSP implementations](https://langserver.org)
*  a. Setup the Nodejs environment if select coc.nvim as LSP client, coc.nvim require nodejs >= 10.12, more information see the [coc.nvim](https://github.com/neoclide/coc.nvim)
*    git clone https://github.com/nodejs/node ~/.vim/nodejs (refer [Download](https://nodejs.org/en/download/) for more installation ways)
*    cd ~/.vim/nodejs
*    git checkout -b current remotes/origin/vxxxx (use 'git branch -avv' find 'Current' branch as proposal)
*    ./configure && make -j4 (check ~/.vim/nodejs/BUILDING.md)
*    sudo make install
*    node -v
*    Launch vim and run :PluginInstall(keymap: < F10 >)
