"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: javascript.jsx
" Maintainer: Qiming <chemzqm@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('b:did_indent')
  let s:did_indent = b:did_indent
  unlet b:did_indent
endif

runtime! indent/xml.vim

let s:keepcpo = &cpo
set cpo&vim

if exists('s:did_indent')
  let b:did_indent = s:did_indent
endif

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

  if (SynXMLish(prevsyn) || SynJSXBlockEnd(prevsyn)) &&
        \ SynJSXContinues(cursyn, prevsyn)
    let ind = XmlIndentGet(v:lnum, 0)
    let currline = getline(v:lnum)
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

let &cpo = s:keepcpo
unlet s:keepcpo

