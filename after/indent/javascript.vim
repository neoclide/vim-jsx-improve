"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: javascript.jsx
" Maintainer: Qiming <chemzqm@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:keepcpo = &cpo
set cpo&vim
let b:did_indent = 1

setlocal indentexpr=GetJsxIndent()
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e,*<Return>,<>>,<<>,/

if exists('*shiftwidth')
  function! s:sw()
    return shiftwidth()
  endfunction
else
  function! s:sw()
    return &sw
  endfunction
endif

let s:endtag = '^\s*\/\?>\s*;\='
let s:real_endtag = '\s*<\/\+[A-Za-z]*>'
let s:return_block = '\s*return\s\+('

let s:has_vim_javascript = exists('*GetJavascriptIndent')

let s:true = !0
let s:false = 0

function! SynSOL(lnum)
  return map(synstack(a:lnum, 1), 'synIDattr(v:val, "name")')
endfunction

function! SynEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! SynAttrJSX(synattr)
  return a:synattr =~ "^jsx"
endfunction

function! SynXMLish(syns)
  return SynAttrJSX(get(a:syns, -1))
endfunction

function! SynJSXBlockEnd(syns)
  return get(a:syns, -1) =~ '\%(js\|javascript\)Braces' ||
      \  SynAttrJSX(get(a:syns, -2))
endfunction

function! SynJSXDepth(syns)
  return len(filter(copy(a:syns), 'v:val ==# "jsxRegion"'))
endfunction

function! SynJSXCloseTag(syns)
  return len(filter(copy(a:syns), 'v:val ==# "jsxCloseTag"'))
endfunction

function! SynJsxAttrib(syns)
  return len(filter(copy(a:syns), 'v:val ==# "jsxAttrib"'))
endfunction

function! SynJsxTag(syns)
  return len(filter(copy(a:syns), 'v:val ==# "jsxTag"'))
endfunction

function! SynJsxEscapeJs(syns)
  return len(filter(copy(a:syns), 'v:val ==# "jsxEscapeJs"'))
endfunction

function! SynJSXContinues(cursyn, prevsyn)
  let curdepth = SynJSXDepth(a:cursyn)
  let prevdepth = SynJSXDepth(a:prevsyn)

  return prevdepth == curdepth ||
      \ (prevdepth == curdepth + 1 && get(a:cursyn, -1) ==# 'jsxRegion')
endfunction

function! GetJsxIndent()
  let cursyn  = SynSOL(v:lnum)
  let prevsyn = SynEOL(v:lnum - 1)
  let nextsyn = SynEOL(v:lnum + 1)
  let currline = getline(v:lnum)

  if (SynXMLish(prevsyn) || currline =~# '\v\s*\<') && SynJSXContinues(cursyn, prevsyn)
    let ind = XmlIndentGet(v:lnum, 0)
    let preline = getline(v:lnum - 1)

    " Open brace
    if currline =~# '^\s*{'
      return ind - s:sw()
    endif

    " return ( | return (
    "   <div>  |   <div>
    "   </div> |   </div>
    " ##);     | ); <--
    if currline =~# 'return\s\+('
      return ind + s:sw()
    endif

    if preline =~? s:endtag || preline =~? '\v^\s*\}+$'
      return ind + s:sw()
    endif


    " <div           | <div
    "   hoge={       |   hoge={
    "   <div></div>  |   ##<div></div>
    if SynJsxEscapeJs(prevsyn) && !(preline =~? '}') && preline =~? '{'
      let ind = ind + s:sw()
    endif

    " <div            | <div
    "   hoge={        |   hoge={
    "     <div></div> |     <div></div>
    "     }           |   }##
    if currline =~? '}$' && !(currline =~? '{')
      let ind = ind - s:sw()
    endif

    if currline =~# '^\s*)' && SynJSXCloseTag(prevsyn)
      let ind = ind - s:sw()
    endif
  else
    let prevline = getline(v:lnum - 1)
    if prevline =~# s:return_block && getline(v:lnum) !~# '^\s*)'
      let ind = indent(v:lnum - 1) + s:sw()
    else
      let ind = GetJavascriptIndent()
    endif
  endif
  return ind
endfunction

if !exists('b:xml_indent_open')
  let b:xml_indent_open = '.\{-}<\a'
endif

if !exists('b:xml_indent_close')
  let b:xml_indent_close = '.\{-}</'
endif

function! <SID>XmlIndentWithPattern(line, pat)
  let s = substitute('x'.a:line, a:pat, "\1", 'g')
  return strlen(substitute(s, "[^\1].*$", '', ''))
endfunction

" [-- return the sum of indents of a:lnum --]
function! <SID>XmlIndentSum(lnum, style, add)
  let line = getline(a:lnum)
  if a:style == match(line, '^\s*</')
    return (&sw *
          \  (<SID>XmlIndentWithPattern(line, b:xml_indent_open)
          \ - <SID>XmlIndentWithPattern(line, b:xml_indent_close)
          \ - <SID>XmlIndentWithPattern(line, '.\{-}/>'))) + a:add
  else
    return a:add
  endif
endfunction

" [-- check if it's xml --]
function! <SID>XmlIndentSynCheck(lnum)
  if '' != &syntax
    let syn1 = synIDattr(synID(a:lnum, 1, 1), 'name')
    let syn2 = synIDattr(synID(a:lnum, strlen(getline(a:lnum)) - 1, 1), 'name')
    if '' != syn1 && syn1 !~ 'xml' && '' != syn2 && syn2 !~ 'xml'
      " don't indent pure non-xml code
      return 0
    elseif syn1 =~ '^xmlComment' && syn2 =~ '^xmlComment'
      " indent comments specially
      return -1
    endif
  endif
  return 1
endfunction

function! XmlIndentGet(lnum, use_syntax_check)
  " Find a non-empty line above the current line.
  let lnum = prevnonblank(a:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  if a:use_syntax_check
    let check_lnum = <SID>XmlIndentSynCheck(lnum)
    let check_alnum = <SID>XmlIndentSynCheck(a:lnum)
    if 0 == check_lnum || 0 == check_alnum
      return indent(a:lnum)
    elseif -1 == check_lnum || -1 == check_alnum
      return -1
    endif
  endif

  let ind = <SID>XmlIndentSum(lnum, -1, indent(lnum))
  let ind = <SID>XmlIndentSum(a:lnum, 0, ind)

  return ind
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
