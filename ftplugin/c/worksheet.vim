let s:plugin_root = simplify(expand('<sfile>:h>') . '/../..')

" Look under `<plug_root>/tool` dir. for installations.
let s:tool_dir = simplify(s:plugin_root . '/tool')

" Add <plug>/python to system path,
" so we can import our python modules.
python << EOF
import vim
import os, sys

plug_root = vim.eval("s:plugin_root")
python_dir = os.path.realpath(os.path.join(plug_root, "python"))

if python_dir not in sys.path:
    sys.path.insert(0, python_dir)

from cworksheet.versions import *
from cworksheet.releases import *
EOF



function! s:find_worksheetify_script()
    " Check in <PLUGDIR>/tools/ for a distribution,
    " and use that if the above variable isn't set.

    python << EOF
import vim

tool_dir = vim.eval("s:tool_dir")

# Doesn't matter if tool dir doesn't exist; wsfy_script will just be '' if so.
# C-Worksheetify at least version `0.2.2`, bin name `c-worksheetify-server`.
rs = find_runscripts_under_folder(tool_dir, "c-worksheetify-server")
wsfy_script = script_with_latest_version(rs, at_least = "0.2.2")

EOF

    return pyeval('wsfy_script')
endfunction



" If .vimrc doesn't specify path to `cworksheet`,
" try and look for it in the plugin folder.
" otherwise, assume it's on the PATH.
if !exists("g:cworksheetify_server_command")
    let g:cworksheetify_server_command = s:find_worksheetify_script()

    " If couldn't find, then, default to PATH
    if len(g:cworksheetify_server_command) == 0
        echom "Couldn't find Worksheetify server. Downloading... [Please wait a moment]"
        call mkdir(s:tool_dir)
        python install_latest_version(tool_dir)

        " Try again.. should have success this time,
        " since there's a file there now.
        let g:cworksheetify_server_command = s:find_worksheetify_script()
    endif
endif



if !exists("g:cworksheetify_server_port")
    let g:cworksheetify_server_port = 10110
endif



" Keymaps

" <leader>w .. save,evaluate,save.
nnoremap <buffer> <localleader>w :call cworksheet#CWorksheetClear()<cr>:w<cr>:call cworksheet#CWorksheetEvaluate()<cr>:w<cr>
nnoremap <buffer> <localleader>e :call cworksheet#CWorksheetClear()<cr>:w<cr>
