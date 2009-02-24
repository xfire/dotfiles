" File: VBlockquote.vim
"
" Purpose: Insert (Quote) stuff the way some emacs people do.
" Example:
" ,----[ title ]
" | Inspired by Blockquote.vim
" | by Tilmann Bitterberg <tilmann@bitterberg.de>
" | ...
" `----
"
" Use: visually select text and
"	:call VBlockquote()
"	or if you want to create a title
"	:call VBlockquote("title")
"	or use the visual mapping "üb".
"
" Author: Ralf Arens <ralf.arens@gmx.net>
" Last Modified: 2000-11-25 16:17:06 CET
" + Added a mapping by Arne Hoffmann <a.r.n.e@gmx.net>.
" + (I improved it a little bit. :-)


function! VBlockquote(...) range
    " put `| ' at beginning of line
    exe a:firstline.",".a:lastline."s/^/| /"
    " remove trailing whitespaces
    exe a:firstline.",".a:lastline.'s/^| $/|/e'
    " generate tail
    exe a:lastline."put ='`----'"
    " set mark
    normal m'
    " generate title
    let @z = ',----'
    if (a:0 != 0)
        " -> extra argument a:1
        let @z = @z."[ ".a:1." ]"
    endif
    exe a:firstline."put! z"
    " jump back to mark
    normal ''
endfunction
