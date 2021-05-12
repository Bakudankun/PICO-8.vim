scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


function! pico8#get_config(key, ...) abort
  let default = a:0 > 0 ? a:1 : 0
  if !has_key(g:, 'pico8_config')
    return default
  endif
  return get(g:pico8_config, a:key, default)
endfunction


function! pico8#run(mods, options) abort
  let cmdline = '"' . pico8#get_config('pico8_path', 'pico8') . '" -run ' . expand('%:S')
  if has('win32')
    " PICO-8 on Windows does not output logs if run directly.
    let cmdline = 'cmd.exe /C "' . cmdline . '"'
  endif

  if has('nvim')
    execute a:mods 'split' join(filter(a:options, 'v:val =~ "^+"')) 'term://' . fnameescape(cmdline)
  else
    execute a:mods 'terminal' join(filter(a:options, 'v:val =~ "^++"')) cmdline
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
