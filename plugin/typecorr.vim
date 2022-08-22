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

if !hasmapto('<Plug>TypecorrOpenrelatedtestfile')
  map <unique> <Leader>gt  <Plug>TypecorrOpenrelatedtestfile
endif
if !hasmapto('<Plug>TypecorrOpenrelatedsourcefile')
  map <unique> <Leader>gs  <Plug>TypecorrOpenrelatedsourcefile
endif
if !hasmapto('<Plug>TypecorrOpenrelatedheaderfile')
  map <unique> <Leader>gh  <Plug>TypecorrOpenrelatedheaderfile
endif
if !hasmapto('<Plug>TypecorrOpenrelatedquintfile')
  map <unique> <Leader>gq  <Plug>TypecorrOpenrelatedquintfile
endif
if !hasmapto('<Plug>TypecorrOpenrelatedexamplefile')
  map <unique> <Leader>ge  <Plug>TypecorrOpenrelatedexamplefile
endif
noremap <unique> <script> <Plug>TypecorrOpenrelatedtestfile  <SID>Openrelatedtestfile
noremap <unique> <script> <Plug>TypecorrOpenrelatedsourcefile  <SID>Openrelatedsourcefile
noremap <unique> <script> <Plug>TypecorrOpenrelatedheaderfile  <SID>Openrelatedheaderfile
noremap <unique> <script> <Plug>TypecorrOpenrelatedquintfile  <SID>Openrelatedquintfile
noremap <unique> <script> <Plug>TypecorrOpenrelatedexamplefile  <SID>Openrelatedexamplefile

noremap <SID>Openrelatedtestfile  :call <SID>Openrelatedfile("test")<CR>
noremap <SID>Openrelatedsourcefile  :call <SID>Openrelatedfile("source")<CR>
noremap <SID>Openrelatedheaderfile  :call <SID>Openrelatedfile("header")<CR>
noremap <SID>Openrelatedquintfile  :call <SID>Openrelatedfile("quint")<CR>
noremap <SID>Openrelatedexamplefile  :call <SID>Openrelatedfile("example")<CR>

function s:Openrelatedfile(type)
  let l:current_file_full_filename = @%
  let l:extraction_command = "/Users/markoates/Repos/blast/bin/programs/project_filename_generator -x" . l:current_file_full_filename . " -B"

  " echom "Current full filename: " . l:current_file_full_filename
  " echom "Extraction command: " . l:extraction_command

  let l:program_usage = system(l:extraction_command)
  " echom "BASENAME EXTRACTED: " . l:program_usage

  if a:type == "test"
    let l:extraction_command = "/Users/markoates/Repos/blast/bin/programs/project_filename_generator -x" . l:current_file_full_filename . " -t"
    let l:filename_to_open = system(l:extraction_command)
  elseif a:type == "source"
    let l:extraction_command = "/Users/markoates/Repos/blast/bin/programs/project_filename_generator -x" . l:current_file_full_filename . " -s"
    let l:filename_to_open = system(l:extraction_command)
  elseif a:type == "header"
    let l:extraction_command = "/Users/markoates/Repos/blast/bin/programs/project_filename_generator -x" . l:current_file_full_filename . " -h"
    let l:filename_to_open = system(l:extraction_command)
  elseif a:type == "quint"
    let l:extraction_command = "/Users/markoates/Repos/blast/bin/programs/project_filename_generator -x" . l:current_file_full_filename . " -q"
    let l:filename_to_open = system(l:extraction_command)
  elseif a:type == "example"
    let l:extraction_command = "/Users/markoates/Repos/blast/bin/programs/project_filename_generator -x" . l:current_file_full_filename . " -e"
    let l:filename_to_open = system(l:extraction_command)
  else
    echom "Error: unrecognized related file type"
    return
  endif

  if filereadable(l:filename_to_open)
    exe ":e " . l:filename_to_open
  else
    echom "Error: filename \"" . l:filename_to_open . "\" not found."
  endif
endfunction

" This is just an added comment to test hash version checking

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
