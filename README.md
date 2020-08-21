# .vim(Gvim on Win32 please see master-gui:README.md)

## Installation
__1. Clone .vim:__
```bash
git clone https://github.com/Shaiya2688/.vim ~/.vim
```

__2. Install the latest version of VIM (support minimum version v8.2):__
```bash
git clone https://github.com/vim/vim.git ~/.vim/vim
cd ~/.vim/vim/src
make distclean    # if you build vim before)
# use './configure --help' for help if need
./configure --enable-fail-if-missing --with-features=huge --enable-pythoninterp=yes --enable-python3interp=yes --enable-cscope --enable-terminal 
make
# for features included(+) or not(-) check
./vim --version
sudo make install
```

__3. Setup vim-plug manager:__
```bash
git clone https://github.com/junegunn/vim-plug ~/.vim/bundle/vim-plug
```

__4. Install Plugins:__
Launch ```vim``` and run ```:PluginInstall``` (keymap: ```<F10>```)

__5. About Keymap Usage:__
Launch vim and type ```<Ctrl-F1>``` to show keymap usage information

## Optional Installation
__1. Setup the optional tools environment:__
```bash
# source "envsetup.sh" in ~/.bashrc as below:
if [ -f ~/.vim/optional-tools/envsetup.sh ]; then
    . ~/.vim/optional-tools/envsetup.sh
fi
```
__2. LSP client and Language Servers environment setup__
>*[What is the Language Server Protocol?](https://microsoft.github.io/language-server-protocol)*

>LSP client and Language Servers check *[LSP implementations](https://langserver.org)*

+ Setup the [Nodejs](https://nodejs.org/en/download/) environment if select [coc.nvim](https://github.com/neoclide/coc.nvim) as LSP client,  [coc.nvim](https://github.com/neoclide/coc.nvim) require [Nodejs](https://nodejs.org/en/download/) >= ```10.12```, more information see the [coc.nvim](https://github.com/neoclide/coc.nvim)
```bash
git clone https://github.com/nodejs/node ~/.vim/nodejs 
cd ~/.vim/nodejs
# use 'git branch -avv' find 'Current' branch as proposal
git checkout -b current remotes/origin/vxxxx
# check ~/.vim/nodejs/BUILDING.md
./configure && make -j4
sudo make install
node -v
``` 
Refer *[Nodejs Download](https://nodejs.org/en/download/)* for more installation ways

After installing the Nodejs, Launch ```vim``` and run ```:PluginInstall``` (keymap: ```<F10>```)


