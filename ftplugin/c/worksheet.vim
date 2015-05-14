" Run python scripts from same directory as this script.
execute "pyfile " . expand("<sfile>:h") . "/versions.py"
execute "pyfile " . expand("<sfile>:h") . "/releases.py"



" If .vimrc doesn't specify path to `cworksheet`,
" try and look for it in the plugin folder.
" otherwise, assume it's on the PATH.
if !exists("g:cworksheetify_server_command")
    " Check in <PLUGDIR>/tools/ for a distribution,
    " and use that if the above variable isn't set.

    " Look under `<plug_root>/tool` dir.
    let s:plugin_root = expand('<sfile>:h>') . '/../..'
    let s:tool_dir = s:plugin_root . '/tool'

    python << EOF
import vim

tool_dir = vim.eval("s:tool_dir")

# Doesn't matter if tool dir doesn't exist; wsfy_script will just be '' if so.
# C-Worksheetify at least version `0.2.2`, bin name `c-worksheetify-server`.
rs = find_runscripts_under_folder(tool_dir, "c-worksheetify-server")
wsfy_script = script_with_latest_version(rs, at_least = "0.2.2")

EOF

    let g:cworksheetify_server_command = pyeval('wsfy_script')

    " If couldn't find, then, default to PATH
    if len(g:cworksheetify_server_command) == 0
        echom "Couldn't find Wsfy Server, as var, nor under tools."
        let g:cworksheetify_server_command = "c-worksheetify-server"
    endif
endif



if !exists("g:cworksheetify_server_port")
    let g:cworksheetify_server_port = 10110
endif



" Keymaps

" <leader>w .. save,evaluate,save.
nnoremap <buffer> <localleader>w :call cworksheet#CWorksheetClear()<cr>:w<cr>:call cworksheet#CWorksheetEvaluate()<cr>:w<cr>
nnoremap <buffer> <localleader>e :call cworksheet#CWorksheetClear()<cr>:w<cr>
