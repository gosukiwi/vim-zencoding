function! zencoding#getword() abort
  let line = getline('.')
  let start = col('.') - 1
  while start > 0 && line[start - 1] =~ '\a\|\.\|#\|-'
    let start -= 1
  endwhile

  return line[start:col('.') - 2]
endfunction


" Gets a list of classes and ids in a given line
function! zencoding#get_classes_and_ids(initial, classesAndIds) abort
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

function! zencoding#build_tag(tagname, attributes) abort
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

function! zencoding#expand(is_self_closing) abort
  let line = zencoding#getword()
  let matches = matchlist(line, '^\([a-zA-Z-]\+\)\([.#]\|$\)')
  echom matches
  if len(matches) == 0
    " try matching with an initial dot or numeral, and default tagname to
    " `div`
    let matches = matchlist(line, '^\([.#]\|$\)')

    " nothing found
    if len(matches) == 0
      return ''
    endif

    let tagname = 'div'
    let initial = matches[1]
  else
    let tagname = matches[1]
    let initial = matches[2]
  endif

  " build tag
  if initial == '' " no attributes defined
    let tag = zencoding#build_tag(tagname, [])
  else " attributes defined, get classes and ids
    let classesAndIds = substitute(line, tagname, '', '')
    let attributes = zencoding#get_classes_and_ids(initial, classesAndIds)
    let tag = zencoding#build_tag(tagname, attributes)
  endif

  " insert tag
  if a:is_self_closing
    return "\<Esc>v" . (len(line) - 1) . "hc" . tag['self']
  else
    return "\<Esc>v" . (len(line) - 1) . "hc" . tag['open'] . tag['close'] . "\<Esc>%i"
  endif
endfunction
