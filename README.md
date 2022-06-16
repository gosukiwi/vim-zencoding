# zencoding.vim
This plugin is a minimalist _Emmet_ (a.k.a zencoding) implementation for Vim.

It only parses ids and classes (so no nested tags), and works for standard
HTML as well as React's JSX.

```
INPUT              RESULT                           KEYBINDING       FILE FORMAT
================================================================================
div                <div></div>                      <C-x><C-Space>             *
--------------------------------------------------------------------------------
div.foo            <div class="foo"></div>          <C-x><C-Space>             *
--------------------------------------------------------------------------------
.foo               <div class="foo"></div>          <C-x><C-Space>             *
--------------------------------------------------------------------------------
div.foo#bar        <div class="foo" id="bar"><div>  <C-x><C-Space>             *
--------------------------------------------------------------------------------
.foo#bar           <div class="foo" id="bar"><div>  <C-x><C-Space>             *
--------------------------------------------------------------------------------
div.foo            <div className="foo"></div>      <C-x><C-Space>           JSX
--------------------------------------------------------------------------------
div                <div>                            <C-x><C-x><C-Space>        *
--------------------------------------------------------------------------------
div.foo            <div class="foo">                <C-x><C-x><C-Space>        *
--------------------------------------------------------------------------------
.foo               <div class="foo">                <C-x><C-x><C-Space>        *
--------------------------------------------------------------------------------
div.foo#bar        <div class="foo" id="bar">       <C-x><C-x><C-Space>        *
--------------------------------------------------------------------------------
.foo#bar           <div class="foo" id="bar">       <C-x><C-x><C-Space>        *
--------------------------------------------------------------------------------
div.foo            <div className="foo" />          <C-x><C-x><C-Space>      JSX
--------------------------------------------------------------------------------
```

See the [documentation](doc/zencoding.txt) for all the details.
