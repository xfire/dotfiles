" Vim html_umlaute plugin, 
" Version: 1.1
" 
" Description:
" When loading a html file, this plugin replaces all
" HTML-coded German Umlauts (like &auml;) with the 
" normal representation (ä). It also knows &szlig;
"
" I don't know if it works with every charset... I could
" only try it with my Vim 6.1 on a RedHat box.
" If wrong char's appear in your file, edit this script
" so it knows the correct ones.
" 
" Maintainer: Timo Teifel <timo at teifel-net dot de>
" 
" Usage:
" It does everything automatically. When reading a file,
" it replaces &?uml; with the corresponding Umlauts, and
" &szlig; with ß.
" When saving, it replaces the special Characters with the
" html-Code, undoing it after the write, to keep the chars
" if you keep working with the file.
"
" Installation:
" Save this file as ~/.vim/plugin/html_umlaute.vim or :source
" it manually when needed
"
" Licence: GPL v2.0 or any later version
"
" Changelog:
" v1.1, 07 Feb 2004
"  - 'report' option switches warnings off 
" v1.0, 14 Dec 2003
"  - initial release

" do this only once per buffer:
if exists("b:loaded_html_umlaute")
    finish
endif
let b:loaded_html_umlaute = 1

if has("autocmd")
augroup html_Umlaute
    au!
    " au FileType      html                   call s:Html2Char()
    au BufWrite      *.html,*.htm,*.xhtml   call s:Char2Html()
    " au BufWritePost  *.html,*.htm,*.xhtml   call s:Html2Char()
augroup END
endif


" functions need to be sourced only once per session
if exists("s:loaded_html_umlaute_functions")
  finish
endif
let s:loaded_html_umlaute_functions = 1

function s:Html2Char()
    " remember cursor position:
	let s:line = line(".")
	let s:column = col(".")
    " if more than 'report' substitutions have been done, vim 
    " displays it.
    let s:save_report = &report
    set report=99999
    %s/&auml;/ä/eIg
    %s/&ouml;/ö/eIg
    %s/&uuml;/ü/eIg
    %s/&Auml;/Ä/eIg
    %s/&Ouml;/Ö/eIg
    %s/&Uuml;/Ü/eIg
    %s/&szlig;/ß/eIg
    let &report=s:save_report
    unlet s:save_report
    call cursor(s:line,s:column)
    unlet s:line
    unlet s:column
endfunction

function s:Char2Html()
	let s:line = line(".")
	let s:column = col(".")
    let s:save_report = &report
    set report=99999
    %s/ä/\&auml;/eIg
    %s/ö/\&ouml;/eIg
    %s/ü/\&uuml;/eIg
    %s/Ä/\&Auml;/eIg
    %s/Ö/\&Ouml;/eIg
    %s/Ü/\&Uuml;/eIg
    %s/ß/\&szlig;/eIg
    let &report=s:save_report
    unlet s:save_report
    call cursor(s:line,s:column)
    unlet s:line
    unlet s:column
endfunction

