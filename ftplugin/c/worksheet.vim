" If .vimrc doesn't specify path to `cworksheet`,
" assume it's on the PATH.
if !exists("g:cworksheet_command")
    let g:cworksheet_command = "c-worksheet-instrumentor"
endif


" Keymaps

" <leader>w .. save,evaluate,save.
nnoremap <buffer> <localleader>w :w<cr>:call cworksheet#CWorksheetEvaluate()<cr>:w<cr>
nnoremap <buffer> <localleader>e :call cworksheet#CWorksheetClear()<cr>:w<cr>
