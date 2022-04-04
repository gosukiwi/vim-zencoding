# zen-coding.vim
This plugin is a minimalist _Emmet_ (a.k.a zencoding) implementation for Vim.
It only parses ids and classes, and works for standard HTML as well as React's
JSX.

```
INPUT              RESULT                        KEYBINDING          FILE FORMAT
================================================================================
foo                <foo>                         <C-X><C-Space>
                   </foo>
--------------------------------------------------------------------------------
foo.bar            <foo class="bar">             <C-X><C-Space>
                   </foo>
--------------------------------------------------------------------------------
foo.bar#baz        <foo class="bar" id="baz">    <C-X><C-Space>
                   </foo>
--------------------------------------------------------------------------------
foo.bar            <foo className="bar">         <C-X><C-Space>              JSX
                   </foo>
--------------------------------------------------------------------------------
```
