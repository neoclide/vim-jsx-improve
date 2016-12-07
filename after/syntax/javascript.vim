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

"  <tag></tag>
" s~~~~~~~~~~~e
syntax region jsxRegion
      \ start=+<\z([^ /!?<>"'=:]\+\)+
      \ skip=+<!--\_.\{-}-->+
      \ end=+</\z1\_\s\{-}[^(=>)]>+
      \ end=+>\n\?\s*)\@=+
      \ end=+>\n\?\s*}\@=+
      \ end=+>;\@=+
      \ end=+\n\?\s\*,+
      \ end=+\s*,\@=+
      \ end=+\s\+:\@=+
      \ fold
      \ contains=jsBlock,jsxTag,jsxCloseTag,jsxComment,
                \@Spell
      \ keepend
      \ extend

" <tag id="sample">
" s~~~~~~~~~~~~~~~e
syntax region jsxTag
      \ matchgroup=jsxCloseTag
      \ start=+<[^ }/!?<>"'=:]\@=+
      \ end=+\/\?>+
      \ contained
      \ contains=jsxTagName,jsxAttrib,jsxEqual,jsxString,jsxEscapeJs

" </tag>
" ~~~~~~
syntax region jsxCloseTag
      \ start=+</[^ /!?<>"'=:]\@=+
      \ end=+>+
      \ contained
      \ contains=jsxCloseString

syntax match jsxCloseString
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
    \ +[-'"<]\@<!\<[a-zA-Z:_][-.0-9a-zA-Z0-9:_]*\>\(['">]\@!\|$\)+
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
    \ start=+=\@<={+
    \ end=+}\ze\%(\/\|\n\|\s\|>\)+
    \ contains=TOP
    \ keepend
    \ extend

syntax match jsxIfOperator +?+
syntax match jsxElseOperator +:+

syntax cluster jsExpression add=jsxRegion

highlight def link jsxTagName htmlTagName
highlight def link jsxEqual htmlTag
highlight def link jsxString String
highlight def link jsxNameSpace Function
highlight def link jsxComment Error
highlight def link jsxAttrib htmlArg
highlight def link jsxEscapeJs jsxEscapeJs
highlight def link jsxCloseTag htmlTag
highlight def link jsxCloseString htmlTagName
highlight def link jsxAttributeBraces htmlTag

let b:current_syntax = 'javascript.jsx'

let &cpo = s:jsx_cpo
unlet s:jsx_cpo
