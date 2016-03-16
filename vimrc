" =========================================================
" This .vimrc file is tailored for my personal use, as it should be.
" It is the top level file that sources all other configuations
" and settings.
" =========================================================

" All of the plugins are installed with Vundle from this file.
source ~/.vim/vundle.vim

" Automatically detect file types -- (must be turned on after Vundle)
filetype plugin indent on

" All of the vim configuation.
source ~/.vim/config.vim

" Plugin specific configuation
source ~/.vim/plugins.vim

" Key Mappings
source ~/.vim/mappings.vim

" Load all the auto commands
source ~/.vim/autocmds.vim

" Load all custom functions
source ~/.vim/functions.vim

