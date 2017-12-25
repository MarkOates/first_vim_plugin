" Vim global plugin for correcting typing mistakes
" Last Change:	2000 Oct 15
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" License:	This file is placed in the public domain.

if exists("g:loaded_typecorr")
  finish
endif
let g:loaded_typecorr = 1

let s:save_cpo = &cpo
set cpo&vim

let s:count = 0


"
" Map key things
"

" Openrelatedfile

if !hasmapto('<Plug>TypecorrOpenrelatedfile')
  map <unique> <Leader>gt  <Plug>TypecorrOpenrelatedfile
endif
noremap <unique> <script> <Plug>TypecorrOpenrelatedfile  <SID>Openrelatedfile

noremap <SID>Openrelatedfile  :call <SID>Openrelatedfile("test")<CR>

function s:Openrelatedfile(type)
  let basename = expand('%:t:r')
  let extension = expand('%:e')

  if a:type == "test"
    let filename_to_find = basename . "Test.cpp"
  elseif a:type == "source"
    let filename_to_find = basename . ".cpp"
  elseif a:type == "header"
    let filename_to_find = basename . ".h"
  else
    echo "Error: unrecognized related file type"
    return
  endif

"  echo filename_to_find
  let found_filename = split(globpath(".", "**/" . filename_to_find), '\n')[0]
  exe ":e " . found_filename
endfunction

" Add

if !hasmapto('<Plug>TypecorrAdd')
  map <unique> <Leader>a  <Plug>TypecorrAdd
endif
noremap <unique> <script> <Plug>TypecorrAdd  <SID>Add

noremap <SID>Add  :call <SID>Add(expand("<cword>"), 1)<CR>

" + menu commands

noremenu <script> Plugin.Add\ Correction      <SID>Add


"
" Functions
"

function s:Add(from, correct)
  let to = input("type the correction for " . a:from . ": ")
  exe ":iabbrev " . a:from . " " . to
  if a:correct | exe "normal viws\<C-R>\" \b\e" | endif
  let s:count = s:count + 1
  echo s:count . " corrections now"
endfunction

if !exists(":Correct")
  command -nargs=1  Correct  :call s:Add(<q-args>, 0)
endif

let &cpo = s:save_cpo
