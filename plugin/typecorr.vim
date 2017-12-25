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
  map <unique> <Leader>gt  <Plug>TypecorrOpenrelatedtestfile
  map <unique> <Leader>gs  <Plug>TypecorrOpenrelatedsourcefile
  map <unique> <Leader>gh  <Plug>TypecorrOpenrelatedheaderfile
endif
noremap <unique> <script> <Plug>TypecorrOpenrelatedtestfile  <SID>Openrelatedtestfile
noremap <unique> <script> <Plug>TypecorrOpenrelatedsourcefile  <SID>Openrelatedsourcefile
noremap <unique> <script> <Plug>TypecorrOpenrelatedheaderfile  <SID>Openrelatedheaderfile

noremap <SID>Openrelatedtestfile  :call <SID>Openrelatedfile("test")<CR>
noremap <SID>Openrelatedsourcefile  :call <SID>Openrelatedfile("source")<CR>
noremap <SID>Openrelatedheaderfile  :call <SID>Openrelatedfile("header")<CR>

function s:Openrelatedfile(type)
  let l:basename = expand('%:t:r')
  let l:extension = expand('%:e')
  let l:basename = substitute(l:basename, "Test", "", "")

  if a:type == "test"
    let l:filename_to_find = l:basename . "Test.cpp"
  elseif a:type == "source"
    let l:filename_to_find = l:basename . ".cpp"
  elseif a:type == "header"
    let l:filename_to_find = l:basename . ".h"
  else
    echo "Error: unrecognized related file type"
    return
  endif

"  echo filename_to_find
  let l:found_filename = split(globpath(".", "**/" . l:filename_to_find), '\n')[0]
  exe ":tabnew " . l:found_filename
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
