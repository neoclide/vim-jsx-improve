# vim-jsx-improve

Make your javascript files support React jsx correctly.

Javscript syntax from [pangloss/vim-javascript](https://github.com/pangloss/vim-javascript)

Jsx highlight and indent code changed from [MaxMEllon/vim-jsx-pretty](https://github.com/MaxMEllon/vim-jsx-pretty)

* Fixed syntax highlight and indent for React jsx files.
* Works well with xml.vim

This plugin have no dependency, all the code you need for jsx and javascript is
included.

**Note:** you need to disable **vim-javascript** plugin if have installed, I have to
change some highlight group to make it works with jsx.

### Installation

Use pathogen or vundle is recommended. Vundle:

    Plugin 'chemzqm/vim-jsx-improve'

### Quick jump to function braces

You can use `[[` `]]` `[]` `][` to quick jump to `{` `}` position of functions, set `g:jsx_improve_motion_disable` to `1` to disable it.

### GIF

![2016-12-10 01_27_59](https://cloud.githubusercontent.com/assets/251450/21058283/26d3b946-be78-11e6-8b1e-78e146ec3496.gif)

The colorscheme is [gruvbox](https://github.com/morhetz/gruvbox)

The keystroke visualizer is [keycastr](https://github.com/sdeken/keycastr)

### Feed back welcome

Feel free to open a ticket if your have problem with this plugin.

### LICENSE

Copyright 2016 chemzqm@gmail.com

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
