if exists('g:zen_coding_loaded')
  finish
endif
let g:zen_coding_loaded = 1

" Gets a list of classes and ids in a given line
function! s:GetClassesAndIds(initial, classesAndIds) abort
  let classList = []
  let idList = []
  let firstPassType = '#'
  let firstPassList = idList
  let secondPassType = '\.'
  let secondPassList = classList
  if a:initial == '.'
    let firstPassType = '\.'
    let firstPassList = classList
    let secondPassType = '#'
    let secondPassList = idList
  endif
  let classes = split(a:classesAndIds, firstPassType)
  for class in classes
    let parts = split(class, secondPassType)
    call add(firstPassList, parts[0])
    for id in parts[1:]
      call add(secondPassList, id)
    endfor
  endfor

  return { 'class': classList, 'id': idList }
endfunction

function! s:BuildTag(tagname, attributes) abort
  let attrs = []
  let isReact = &filetype =~ 'jsx\|react'
  if isReact
    let selfClosingEnding = ' />'
  else
    let selfClosingEnding = '>'
  endif

  if len(a:attributes) == 0
    return {
          \ 'self':  '<' . a:tagname . selfClosingEnding,
          \ 'open':  '<' . a:tagname . '>',
          \ 'close': '</' . a:tagname . '>' }
  endif

  let classAttributeName = 'class'
  let idAttributeName = 'id'
  if isReact
    let classAttributeName = 'className'
  endif

  let classes = a:attributes['class']
  if len(classes) > 0
    let classAttr = classAttributeName . '="' . join(classes, ' ') . '"'
    call add(attrs, classAttr)
  endif

  let ids = a:attributes['id']
  if len(ids) > 0
    let idAttr = idAttributeName . '="' . join(ids, ' ') . '"'
    call add(attrs, idAttr)
  endif

  let attributesHtml = join(attrs, ' ')
  return {
    \ 'self':  '<' . a:tagname . ' ' . attributesHtml . selfClosingEnding,
    \ 'open':  '<' . a:tagname . ' ' . attributesHtml . '>',
    \ 'close': '</' . a:tagname . '>' }
endfunction

function! s:ZenCodingExpand(isSelfClosing) abort
  let line = trim(getline('.'))
  let matches = matchlist(line, '^\(\i\+\)\([.#]\|$\)')
  if len(matches) == 0
    startinsert!
    return
  endif

  " build tag
  let tagname = matches[1]
  if matches[2] == '' " no attributes defined
    let tag = s:BuildTag(tagname, [])
  else " attributes defined, get classes and ids
    let classesAndIds = substitute(line, tagname, '', '')
    let attributes = s:GetClassesAndIds(matches[2], classesAndIds)
    let tag = s:BuildTag(tagname, attributes)
  endif

  " insert tag
  execute "normal! ^C\<Esc>"
  if a:isSelfClosing
    execute "normal! a" . tag['self'] . "\<Esc>"
    startinsert!
  else
    execute "normal! a" . tag['open'] . tag['close'] . "\<Esc>%i\<Right>"
  endif
endfunction

" Commands
command! ZenCodingExpand silent! call <SID>ZenCodingExpand(0)<CR>
command! ZenCodingSelfClosingExpand silent! call <SID>ZenCodingExpand(1)<CR>

" Mappings
if !exists('g:zen_coding_disable_default_mappings') || g:zen_coding_disable_default_mappings == 0
  inoremap <silent> <C-x><C-Space> <C-O>:ZenCodingExpand<CR>
  inoremap <silent> <C-x><C-b> <C-O>:ZenCodingSelfClosingExpand<CR>
endif
