" ============================================================================
" File:        nerdtree-fzf.vim
" Description: Adds searching capabilities to NERD_Tree
" Maintainer:  Valentin Sushkov <me@vsushkov.com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================


" don't load multiple times
if exists("g:loaded_nerdtree_fzf")
    finish
endif

let g:loaded_nerdtree_ag_fzf = 1

" add the new menu item via NERD_Tree's API
call NERDTreeAddMenuItem({
    \ 'text': '(g)rep in the directory',
    \ 'shortcut': 'g',
    \ 'callback': 'NERDTreeFzf' })

" in comparison to the original Rg, there's no shellescape()
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --sort path --smart-case -- '.<q-args>, 1,
  \   fzf#vim#with_preview(), <bang>0)

function! NERDTreeFzf()
    " get the current dir from NERDTree
    let path = g:NERDTreeDirNode.GetSelected().path
    if path.isSymLink
        let dir = path.symLinkDest
    else
        let dir = path.str()
    endif

    " get the search pattern
    let pattern = input("Enter the pattern: ")
    if pattern == ''
        echo 'Maybe another time...'
        return
    endif

    " display first result in the last window
    wincmd w

    exec "Rg '".pattern."' ".dir
endfunction
