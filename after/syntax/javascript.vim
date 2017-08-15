"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: javascript.jsx
" Maintainer: Qiming <chemzqm@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:jsx_cpo = &cpo
set cpo&vim

syntax case match

if exists('b:current_syntax')
  let s:current_syntax = b:current_syntax
  unlet b:current_syntax
endif

if exists('s:current_syntax')
  let b:current_syntax = s:current_syntax
endif

" <tag id="sample">
" s~~~~~~~~~~~~~~~e
syntax region jsxTag
      \ matchgroup=jsxTag start=+<[^ }/!?<>"'=:]\@=+
      \ matchgroup=jsxTag end=+\/\?>+
      \ contained
      \ contains=jsxTagName,jsxAttrib,jsxEqual,jsxString,jsxEscapeJs

" </tag>
" ~~~~~~
syntax match jsxEndTag
      \ +</[^ /!?<>"']\+>+
      \ contained
      \ contains=jsxEndString

"  <tag></tag>
" s~~~~~~~~~~~e
syntax region jsxRegion
      \ start=+<\z([^ /!?<>"'=:]\+\)+
      \ skip=+<!--\_.\{-}-->+
      \ end=+</\z1\_\s\{-}>+
      \ matchgroup=jsxEndTag end=+/>+
      \ fold
      \ contains=jsxRegion,jsxTag,jsxEndTag,jsxComment,jsxEntity,jsxEscapeJs,jsxString,@Spell
      \ keepend
      \ extend

syntax match jsxEndString
    \ +\w\++
    \ contained

" <!-- -->
" ~~~~~~~~
syntax match jsxComment /<!--\_.\{-}-->/ display

syntax match jsxEntity "&[^; \t]*;" contains=jsxEntityPunct
syntax match jsxEntityPunct contained "[&.;]"

" <tag key={this.props.key}>
"  ~~~
syntax match jsxTagName
    \ +[<]\@<=[^ /!?<>"']\++
    \ contained
    \ display

" <tag key={this.props.key}>
"      ~~~
syntax match jsxAttrib
    \ +[-'"<]\@<!\<[a-zA-Z:_][-.0-9a-zA-Z0-9:_]*\>\(['">]\@!\|\>\|$\)+
    \ contained
    \ contains=jsxAttribPunct,jsxAttribHook
    \ display

syntax match jsxAttribPunct +[:.]+ contained display

" <tag id="sample">
"        ~
syntax match jsxEqual +=+ contained display

" <tag id="sample">
"         s~~~~~~e
syntax region jsxString contained start=+"+ end=+"+ contains=jsxEntity,@Spell display

" <tag id='sample'>
"         s~~~~~~e
syntax region jsxString contained start=+'+ end=+'+ contains=jsxEntity,@Spell display

" <tag key={this.props.key}>
"          s~~~~~~~~~~~~~~e
syntax region jsxEscapeJs matchgroup=jsxAttributeBraces
    \ contained
    \ start=+{+
    \ end=+}\ze\%(\/\|\n\|\s\|<\|>\)+
    \ contains=TOP
    \ keepend
    \ extend

syntax match jsxIfOperator +?+
syntax match jsxElseOperator +:+

syntax cluster jsExpression add=jsxRegion

highlight def link jsxString String
highlight def link jsxNameSpace Function
highlight def link jsxComment Error
highlight def link jsxEscapeJs jsxEscapeJs

if hlexists('htmlTag')
  highlight def link jsxTagName htmlTagName
  highlight def link jsxEqual htmlTag
  highlight def link jsxAttrib htmlArg
  highlight def link jsxTag htmlTag
  highlight def link jsxEndTag htmlTag
  highlight def link jsxEndString htmlTagName
  highlight def link jsxAttributeBraces htmlTag
else
  highlight def link jsxTagName Statement
  highlight def link jsxEndString Statement
  highlight def link jsxEqual Function
  highlight def link jsxTag Function
  highlight def link jsxEndTag Function
  highlight def link jsxAttrib Type
  highlight def link jsxAttributeBraces Special
endif

let b:current_syntax = 'javascript.jsx'

let &cpo = s:jsx_cpo
unlet s:jsx_cpo
