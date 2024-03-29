if exists('g:zencoding_loaded')
  finish
endif
let g:zencoding_loaded = 1

" Mappings
if !exists('g:zencoding_disable_default_mappings') || g:zencoding_disable_default_mappings == 0
  if has('gui_running')
    inoremap <silent> <C-x><C-Space> <C-r>=zencoding#expand(0)<CR>
    inoremap <silent> <C-x><C-x><C-Space> <C-r>=zencoding#expand(1)<CR>
  else
    inoremap <silent> <C-x><C-@> <C-r>=zencoding#expand(0)<CR>
    inoremap <silent> <C-x><C-x><C-@> <C-r>=zencoding#expand(1)<CR>
  endif
endif
