scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:pico8_config')
  let g:pico8_config = {}
endif


let lua_version = 5
let lua_subversion = 2
syn include @lua syntax/lua.vim


syn region pico8Lua transparent matchgroup=pico8Section start="^__lua__$" end="^__\l\+__$"me=s-1 contains=pico8Tab fold
syn region pico8Tab transparent matchgroup=pico8Tab start="^" end="^-->8$" end="^__\l\+__$"me=s-1 keepend contained contains=@lua,pico8Include,pico8Func fold
syn region pico8Gfx transparent matchgroup=pico8Section start="^__gfx__$" end="^__\l\+__$"me=s-1 contains=@pico8Pixel fold
syn region pico8Gff transparent matchgroup=pico8Section start="^__gff__$" end="^__\l\+__$"me=s-1 contains=pico8Flag fold
syn region pico8Label transparent matchgroup=pico8Section start="^__label__$" end="^__\l\+__$"me=s-1 contains=@pico8Pixel fold
syn region pico8Map transparent matchgroup=pico8Section start="^__map__$" end="^__\l\+__$"me=s-1 contains=pico8Sprite fold
syn region pico8Sfx transparent matchgroup=pico8Section start="^__sfx__$" end="^__\l\+__$"me=s-1 contains=pico8Sequence fold
syn region pico8Music transparent matchgroup=pico8Section start="^__music__$" end="^__\l\+__$"me=s-1 contains=pico8Track fold

syn cluster luaNormal contains=luaParen,luaTableBlock,luaFunctionBlock,luaIfThen,
      \luaThenEnd,luaElseifThen,luaBlock,luaLoopBlock

syn match pico8Include contained containedin=@lua "#include\>"
syn keyword pico8Func contained containedin=@luaNormal load save folder dir run stop resume reboot
syn keyword pico8Func contained containedin=@luaNormal info flip printh time t stat extcmd clip pget
syn keyword pico8Func contained containedin=@luaNormal pset sget sset fget fset print cursor color
syn keyword pico8Func contained containedin=@luaNormal cls camera circ circfill line rect rectfill
syn keyword pico8Func contained containedin=@luaNormal pal palt spr sspr fillp add del all foreach
syn keyword pico8Func contained containedin=@luaNormal pairs btn btnp sfx music mget mset map peek
syn keyword pico8Func contained containedin=@luaNormal poke peek2 poke2 peek4 poke4 memcpy reload
syn keyword pico8Func contained containedin=@luaNormal cstore memset max min mid flr ceil cos sin
syn keyword pico8Func contained containedin=@luaNormal atan2 sqrt abs rnd srand band bor bxor bnot
syn keyword pico8Func contained containedin=@luaNormal rotl rotr shl shr lshr menuitem sub type
syn keyword pico8Func contained containedin=@luaNormal tostr tonum cartdata dget dset serial
syn keyword pico8Func contained containedin=@luaNormal cocreate coresume costatus yield
syn keyword pico8Func contained containedin=@luaNormal ls reset oval ovalfill deli count tline chr
syn keyword pico8Func contained containedin=@luaNormal ord split pack unpack

syn sync match pico8 grouphere pico8Lua "^-->8$"
syn sync match pico8 grouphere pico8Lua "^__lua__$"


hi def link pico8Tab luaComment
hi def link pico8Section Title
hi def link pico8Func luaFunc
hi def link pico8Include Include


if get(g:pico8_config, 'colorize_graphics', 1)
  syn match pico8Color0 contained "0"
  syn match pico8Color1 contained "1"
  syn match pico8Color2 contained "2"
  syn match pico8Color3 contained "3"
  syn match pico8Color4 contained "4"
  syn match pico8Color5 contained "5"
  syn match pico8Color6 contained "6"
  syn match pico8Color7 contained "7"
  syn match pico8Color8 contained "8"
  syn match pico8Color9 contained "9"
  syn match pico8ColorA contained "a"
  syn match pico8ColorB contained "b"
  syn match pico8ColorC contained "c"
  syn match pico8ColorD contained "d"
  syn match pico8ColorE contained "e"
  syn match pico8ColorF contained "f"
  syn cluster pico8Pixel contains=pico8Color0,pico8Color1,pico8Color2,pico8Color3,
        \pico8Color4,pico8Color5,pico8Color6,pico8Color7,
        \pico8Color8,pico8Color9,pico8ColorA,pico8ColorB,
        \pico8ColorC,pico8ColorD,pico8ColorE,pico8ColorF

  function! s:highlight_pixels() abort
    let colors = [
          \   {'gui': '#000000', '16color': 'Black',       '256color': '16'},
          \   {'gui': '#1D2B53', '16color': 'DarkBlue',    '256color': '17'},
          \   {'gui': '#7E2553', '16color': 'DarkMagenta', '256color': '89'},
          \   {'gui': '#008751', '16color': 'DarkGreen',   '256color': '29'},
          \   {'gui': '#AB5236', '16color': 'DarkRed',     '256color': '130'},
          \   {'gui': '#5F574F', '16color': 'DarkGray',    '256color': '241'},
          \   {'gui': '#C2C3C7', '16color': 'LightGray',   '256color': '251'},
          \   {'gui': '#FFF1E8', '16color': 'White',       '256color': '255'},
          \   {'gui': '#FF004D', '16color': 'Red',         '256color': '197'},
          \   {'gui': '#FFA300', '16color': 'DarkYellow',  '256color': '214'},
          \   {'gui': '#FFEC27', '16color': 'Yellow',      '256color': '226'},
          \   {'gui': '#00E436', '16color': 'Green',       '256color': '41'},
          \   {'gui': '#29ADFF', '16color': 'Blue',        '256color': '39'},
          \   {'gui': '#83769C', '16color': 'DarkCyan',    '256color': '103'},
          \   {'gui': '#FF77A8', '16color': 'Magenta',     '256color': '211'},
          \   {'gui': '#FFCCAA', '16color': 'Cyan',        '256color': '223'},
          \ ]

    for index in range(len(colors))
      if &t_Co < 256
        let cterm = colors[index].16color
      else
        let cterm = colors[index].256color
      endif
      let gui = colors[index].gui
      execute printf('hi def pico8Color%X ctermbg=%s ctermfg=%s guibg=%s guifg=%s',
            \ index, cterm, cterm, gui, gui)
    endfor
  endfunction

  call s:highlight_pixels()
endif


let b:current_syntax = 'pico8'


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
