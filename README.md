# zen-coding.vim
This plugin is a minimalist _Emmet_ (a.k.a zencoding) implementation for Vim.
It only parses ids and classes (so no nested tags), and works for standard HTML as well as React's
JSX.

```
INPUT              RESULT                        KEYBINDING          FILE FORMAT
================================================================================
div                <div>                         <C-X><C-Space>                *
                   </div>
--------------------------------------------------------------------------------
div.foo            <div class="foo">             <C-X><C-Space>                *
                   </div>
--------------------------------------------------------------------------------
div.foo#bar        <div class="foo" id="bar">    <C-X><C-Space>                *
                   </div>
--------------------------------------------------------------------------------
div.foo            <div className="foo">         <C-X><C-Space>              JSX
                   </div>
--------------------------------------------------------------------------------
div                <div>                         <C-X><C-b>                    *
--------------------------------------------------------------------------------
div.foo            <div class="foo">             <C-X><C-b>                    *
--------------------------------------------------------------------------------
div.foo#bar        <div class="foo" id="bar">    <C-X><C-b>                    *
--------------------------------------------------------------------------------
div.foo            <div className="foo" />       <C-X><C-b>                  JSX
--------------------------------------------------------------------------------
```

See the [documentation](doc/zen-coding.txt) for all the details.
