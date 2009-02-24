" Vim syntax file
" Language:	YML
" Maintainer:	Volker Birk
"
" Options to control YML syntax highlighting:
"
" For highlighted numbers:
"
"    let yml_highlight_numbers = 1
"
" For highlighted builtin functions:
"
"    let yml_highlight_builtins = 1
"
" If you want all possible YML highlighting (the same as setting the
" preceding options):
"
"    let yml_highlight_all = 1
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn keyword ymlStatement	import include decl define as
syn match   ymlComment	"//.*$"
syn region ymlLineQuote matchgroup=Normal start=+|+ end=+$+ skip=+\\\\\|\\|+ contains=ymlCommand,ymlValue
syn region ymlQuote matchgroup=Normal start=+>+ end=+$+ skip=+\\\\\|\\>+ contains=ymlCommand,ymlValue
syn region ymlDirectTags matchgroup=Normal start=+]+ end=+$+ skip=+\\\\\|\\]+
syn region ymlDirectTags matchgroup=Normal start=+<+ end=+$+

" strings
syn region ymlString		matchgroup=Normal start=+[uU]\='+ end=+'+ skip=+\\\\\|\\'+ contains=ymlEscape
syn region ymlString		matchgroup=Normal start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+ contains=ymlEscape
syn region ymlString		matchgroup=Normal start=+[uU]\="""+ end=+"""+ contains=ymlEscape
syn region ymlString		matchgroup=Normal start=+[uU]\='''+ end=+'''+ contains=ymlEscape
syn region ymlRawString	matchgroup=Normal start=+[uU]\=[rR]'+ end=+'+ skip=+\\\\\|\\'+
syn region ymlRawString	matchgroup=Normal start=+[uU]\=[rR]"+ end=+"+ skip=+\\\\\|\\"+
syn region ymlRawString	matchgroup=Normal start=+[uU]\=[rR]"""+ end=+"""+
syn region ymlRawString	matchgroup=Normal start=+[uU]\=[rR]'''+ end=+'''+
syn match  ymlEscape		+\\[abfnrtv'"\\]+ contained
syn match  ymlEscape		"\\\o\{1,3}" contained
syn match  ymlEscape		"\\x\x\{2}" contained
syn match  ymlEscape		"\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match  ymlEscape		"\\$"
syn region ymlCommand       matchgroup=Normal start=+[uU]\=`+ end=+`+ skip=+\\\\\|\\`+
syn region ymlValue         matchgroup=Normal start=+«+ end=+»+ skip=+\\\\\|\\`+

if exists("yml_highlight_all")
  let yml_highlight_numbers = 1
  let yml_highlight_builtins = 1
endif

if exists("yml_highlight_numbers")
  " numbers (including longs and complex)
  syn match   ymlNumber	"\<0x\x\+[Ll]\=\>"
  syn match   ymlNumber	"\<\d\+[LljJ]\=\>"
  syn match   ymlNumber	"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
  syn match   ymlNumber	"\<\d\+\.\([eE][+-]\=\d\+\)\=[jJ]\=\>"
  syn match   ymlNumber	"\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
endif

if exists("yml_highlight_builtins")
  " builtin functions, types and objects, not really part of the syntax
  syn keyword ymlBuiltin	quote_indention quote_text cmd_left cmd_right
endif

" This is fast but code inside triple quoted strings screws it up. It
" is impossible to fix because the only way to know if you are inside a
" triple quoted string is to start from the beginning of the file. If
" you have a fast machine you can try uncommenting the "sync minlines"
" and commenting out the rest.
syn sync match ymlSync grouphere NONE "):$"
syn sync maxlines=200
"syn sync minlines=2000

if version >= 508 || !exists("did_yml_syn_inits")
  if version <= 508
    let did_yml_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink ymlStatement           Statement
  HiLink ymlCommand             Statement
  HiLink ymlValue               Statement
  HiLink ymlString		String
  HiLink ymlRawString           String
  HiLink ymlDirectTags          Function
  HiLink ymlEscape		Special
  HiLink ymlComment		Comment
  HiLink ymlLineQuote           Normal
  HiLink ymlQuote               String
  if exists("yml_highlight_numbers")
    HiLink ymlNumber	Number
  endif
  if exists("yml_highlight_builtins")
    HiLink ymlBuiltin	Function
  endif

  delcommand HiLink
endif

let b:current_syntax = "yml"

" vim: ts=8
