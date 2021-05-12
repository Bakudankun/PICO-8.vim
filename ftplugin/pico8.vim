scriptencoding utf-8

if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/lua.vim

let s:save_cpo = &cpo
set cpo&vim

let b:did_ftplugin = 1


setlocal suffixesadd+=.p8


if pico8#get_config('imitate_console', 1)
  setlocal colorcolumn=33
  setlocal noexpandtab
  setlocal shiftwidth=0
  setlocal tabstop=1
  let b:undo_ftplugin .= ' | setlocal cc< et< sw< ts<'
endif

if pico8#get_config('use_keymap', 1)
  setlocal keymap=pico8
  let b:undo_ftplugin .= ' | setlocal kmp<'
endif

if has('terminal') || has('nvim')
  command! -buffer -nargs=* Pico8Run call pico8#run(<q-mods>, [<f-args>])
  let b:undo_ftplugin .= ' | delcommand Pico8Run'
endif


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
