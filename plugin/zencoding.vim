if exists('g:zencoding_loaded')
  finish
endif
let g:zencoding_loaded = 1

" Commands
" command! ZenCodingExpand silent! call <SID>ZenCodingExpand(0)<CR>
" command! ZenCodingSelfClosingExpand silent! call <SID>ZenCodingExpand(1)<CR>

" Mappings
if !exists('g:zencoding_disable_default_mappings') || g:zencoding_disable_default_mappings == 0
  inoremap <silent> <C-x><C-Space> <C-r>=zencoding#expand(0)<CR>
  inoremap <silent> <C-x><C-x><C-Space> <C-r>=zencoding#expand(1)<CR>
endif
