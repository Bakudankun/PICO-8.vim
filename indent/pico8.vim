scriptencoding utf-8

if exists('b:did_indent')
  finish
endif

runtime! indent/lua.vim

if !exists('*GetLuaIndent')
  finish
endif


let s:save_cpo = &cpo
set cpo&vim


setlocal indentexpr=GetPico8Indent()


function! GetPico8Indent() abort
  let s:save_cursor = getcurpos()

  " Do not indent if the cursor is not in the `__lua__` section
  if search('\(^__lua__$\)\|^__\l\+__$', 'bcnp') != 2
    return 0
  endif

  let prevline = prevnonblank(v:lnum - 1)
  call cursor(prevline, 1)

  " Use lua indent if previous line does not start with `if (` or `while (`
  if !search('^\s*\%(if\|while\)\s*(\zs', 'c', prevline)
    return s:fallback()
  endif

  let close_paren = searchpair('(', '', ')', 'c',
        \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"', prevline)

  " Use lua indent if the parenthesis is not closed within the line
  if close_paren != prevline
    return s:fallback()
  endif

  " Use lua indent if the parenthesis is followed by `then`, `do` or an operator
  if search('\%#)\s*\%(then\|do\|and\|or\|not\|)\|\[\|\]\|,\|+\|-\|\*\|\/\|^\|&\||\|^^\|\~\|<<\|>>\|>>>\|<<>\|>><\|==\|<\|>\|<=\|>=\|\~=\|!=\|,\|\.\|:\)', 'cz', prevline)
    return s:fallback()
  endif

  " Reduce indent by one level from lua's indent unless that line end with that parentheses
  if search('\S', 'z', prevline)
    return max([s:fallback() - shiftwidth(), 0])
  endif

  return s:fallback()
endfunction


function s:fallback() abort
  call setpos('.', s:save_cursor)
  return GetLuaIndent()
endfunction


let b:did_indent = 1


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
