scriptencoding utf-8

if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/lua.vim

let s:save_cpo = &cpo
set cpo&vim

let b:did_ftplugin = 1


setlocal suffixesadd+=.p8


if !exists('g:pico8_config')
  let g:pico8_config = {}
endif

if get(g:pico8_config, 'imitate_console', 1)
  setlocal colorcolumn=33
  setlocal noexpandtab
  setlocal shiftwidth=0
  setlocal tabstop=1
  let b:undo_ftplugin .= ' | setlocal cc< et< sw< ts<'
endif

if get(g:pico8_config, 'use_keymap', 1)
  setlocal keymap=pico8
  let b:undo_ftplugin .= ' | setlocal kmp<'
endif

if has('terminal')
  function! s:pico8_run(mods, options) abort
    let cmdline = '"' . get(g:pico8_config, 'pico8_path', 'pico8') . '" -run %:S'
    if has('win32')
      " PICO-8 on Windows does not output logs if run directly.
      let cmdline = 'cmd.exe /C "' . cmdline . '"'
    endif
    execute a:mods 'terminal' join(filter(a:options, 'v:val =~ "^++"')) cmdline
  endfunction

  command! -buffer -nargs=* Pico8Run call s:pico8_run(<q-mods>, [<f-args>])
  let b:undo_ftplugin .= ' | delcommand Pico8Run'
endif


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
