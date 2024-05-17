if !exists("g:cworksheetify_server_command")
    let g:cworksheetify_server_command = "c-worksheetify-server"
endif



if !exists("g:cworksheetify_server_port")
    let g:cworksheetify_server_port = 10110
endif



" Commands
command! CWorksheetEvaluate call cworksheet#CWorksheetClear() | silent! write | call cworksheet#CWorksheetEvaluate() | silent! write
command! CWorksheetClear call cworksheet#CWorksheetClear() | silent! write



" Keymaps

" <leader>w .. save,evaluate,save.
nnoremap <buffer> <localleader>w :CWorksheetEvaluate<cr>
nnoremap <buffer> <localleader>e :CWorksheetClear<cr>
