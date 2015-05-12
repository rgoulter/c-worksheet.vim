" If .vimrc doesn't specify path to `cworksheet`,
" assume it's on the PATH.
if !exists("g:cworksheetify_server_command")
    " TODO: Check in <PLUGDIR>/tools/ for a distribution,
    "       and use that if the above variable isn't set.
    let g:cworksheetify_server_command = "c-worksheetify-server"
endif

if !exists("g:cworksheetify_server_port")
    let g:cworksheetify_server_port = 10110
endif


" Keymaps

" <leader>w .. save,evaluate,save.
nnoremap <buffer> <localleader>w :call cworksheet#CWorksheetClear()<cr>:w<cr>:call cworksheet#CWorksheetEvaluate()<cr>:w<cr>
nnoremap <buffer> <localleader>e :call cworksheet#CWorksheetClear()<cr>:w<cr>
