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

  if len(a:attributes) == 0
    return {
          \ 'self':  '<' . a:tagname . ' />',
          \ 'open':  '<' . a:tagname . '>',
          \ 'close': '</' . a:tagname . '>' }
  endif

  let classAttributeName = 'class'
  let idAttributeName = 'id'
  if &filetype =~ 'jsx\|react'
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
    \ 'self':  '<' . a:tagname . ' ' . attributesHtml . ' />',
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
  else
    execute "normal! a" . tag['open'] . "\<CR>" . tag['close'] . "\<Esc>"
    execute "normal! O\<Space>\<BS>\<Esc>"
  endif
  startinsert!
endfunction

nnoremap <Plug>ExpandZenCoding :call <SID>ZenCodingExpand(0)<CR>
nnoremap <Plug>ExpandZenCodingSelfClosing :call <SID>ZenCodingExpand(1)<CR>
inoremap <silent> <C-x><C-Space> <C-O>:call <SID>ZenCodingExpand(0)<CR>
inoremap <silent> <C-x><C-b> <C-O>:call <SID>ZenCodingExpand(1)<CR>
