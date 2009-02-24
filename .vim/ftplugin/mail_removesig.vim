"===========================================================================
" File: 	Mail_Sig_set.vim
" Author:	Luc Hermitte <EMAIL:hermitte@free.fr>
" 		<URL:http://hermitte.free.fr>
" Last Update:	03rd jul 2002
"
" Purpose:	Defines a command that deletes signatures at the end of e-mail
"               (/usenet post) replies.
" Bonus:	Defines an operator-pending mapping that will match our own
" 		signature or the end of the file. Very handy when we want to
" 		delete every line of a reply but our signature.
" 		Usage: d-- to delete till the signature/end of the file
" 		       c-- to change till the signature/end of the file
" 		       y-- to yank   till the signature/end of the file
" 		       etc.
"
" Installation:	Drop this file into your $HOME/vimfiles/ftplugin/mail/ 
" 		directory and invokes the EraseSignature command (either from
" 		another file, or this one -- require a little modification).
"
" Requires:	VIM 6.0+
" Thanks:	Cédric Duval for his improvments ; Loic Minier and Yann
" 		Kéhervé for their suggestions and ideas.
"
"===========================================================================

if exists("g:loaded_Mail_Sig_set_vim") | finish | endif
let g:loaded_Mail_Sig_set_vim = 1
"---------------------------------------------------------------------------

onoremap -- /\n^-- \=$\\|\%$/+0<cr>
" explaination of the pattern : {{{
" 1- either match a new line (\n) followed by the double dashed alone on a
"    line
" 2- or match the last line (\%: line ; $:last)
" the {offset} of '+0' permit to match the end of the new line or the very end
" of the file.
" }}}

"---------------------------------------------------------------------------
command! -nargs=0 EraseSignature :call <sid>Erase_Sig()

" Function:	s:Erase_Sig() {{{
" Purpose:	Delete signatures at the end of e-mail replies.
" Features:	* Does not beep when no signature is found
" 		* Also deletes the empty lines (even those beginning by '>')
" 		  preceding the signature.
"		* Do not delete the automatic signature inserted by the MUA
"		* Delete multiple signatures inserted by mailing lists
"---------------------------------------------------------------------------
function! s:Erase_Sig()
  normal G
  " position of our signature if automatically inserted by our MUA
  let s = search('^-- $', 'b')
  let s = (s!=0) ? s : line('$')+1
  " position of a signature from the replied email
  let i = s:SearchSignatureOnce( s-1, s )
  " call confirm('i='.i."  -- s=".s, '&Ok')
  " If found, then
  if i != 0
    " Try to see if an automatic signature from a mailing list has been
    " inserted
    let j = s:SearchSignatureOnce(i-1, s)
    if j != 0 | let i = j | endif
    " Finally, delete these lines plus the signature
    exe 'normal '.i.'Gd'.(s-1).'G'
  endif
endfunction
" }}}

" Function s:SearchSignatureOnce(l,s) {{{
function! s:SearchSignatureOnce(l, pos_self_sig)
  " Search for the signature pattern : "^> -- $"
  exe a:l
  let i = search('^> *-- \=$', 'b')
  " If found, then
  if i != 0
    " 0- check that nothing before
    let j = search('^[^>]', 'W') 
    " call confirm('j='.j."  -- i=".i, '&Ok')
    if (j != 0) && (j<a:pos_self_sig) | return 0 | endif 

    " First, search for the last non empty (non sig) line
    while i >= 1
      let i = i - 1
      " rem : i can't value 1
      if getline(i) !~ '^\(>\s*\)*$'
        break
      endif
    endwhile
    " Second, delete these lines plus the signature
    let i = i + 1
  endif
  return i
endfunction
" }}}

" NB: Uncomment the next line if you want to handle the suppresion of the
" signature from this file only ...
:EraseSignature	" uncomment me ?
"===========================================================================
" vim60: set fdm=marker:
