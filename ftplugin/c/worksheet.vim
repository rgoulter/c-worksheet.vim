if !exists("g:cworksheetify_server_command")
    let g:cworksheetify_server_command = "c-worksheetify-server"
endif



if !exists("g:cworksheetify_server_port")
    let g:cworksheetify_server_port = 10110
endif



" Commands
command! CWorksheetEvaluate call cworksheet#CWorksheetClear() | write | call cworksheet#CWorksheetEvaluate() | write
command! CWorksheetClear call cworksheet#CWorksheetClear() | write



" Keymaps

" <leader>w .. save,evaluate,save.
nnoremap <buffer> <localleader>w :CWorksheetEvaluate<cr>
nnoremap <buffer> <localleader>e :CWorksheetClear<cr>
