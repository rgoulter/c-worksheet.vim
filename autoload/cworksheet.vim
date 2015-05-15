let s:plugin_root = simplify(expand('<sfile>:h>') . '/../..')

" Add <plug>/python to system path,
" so we can import our python modules.
python << EOF
import vim
import os, sys

plug_root = vim.eval("s:plugin_root")
python_dir = os.path.realpath(os.path.join(plug_root, "python"))

if python_dir not in sys.path:
    sys.path.insert(0, python_dir)

from cworksheet.worksheetclient import *
EOF


function! cworksheet#CWorksheetClear()
    " Remove all matches of the regex:
    "   \(\s*\n\)\?\s*\/\/>.*\(\n\s*\/\/|.*\)*
    " i.e. all spaces leading up to //> and to EOL,
    "  as well as any blank lines leading up to //| and to EOL.
    execute "silent! %s/\\(\\s*\\n\\)\\?\\s*\\/\\/>.*\\(\\n\\s*\\/\\/|.*\\)*//"
endfunction


" Need this function for when this plugin has additional flags to
" pass to the cworksheet program.
function! cworksheet#CWorksheetifyServerCommand()
    return g:cworksheetify_server_command . " " . g:cworksheetify_server_port
endfunction


function! cworksheet#CWorksheetEvaluate()
    let cmd = cworksheet#CWorksheetifyServerCommand()

    " Full path of current file/buffer.
    let cSrcFilename = expand("%:p")

    python << EOF
import vim

# Ensure the Worksheetify server is running.
# Assumes that the port given by `g:cworksheetify_server_port` is
#  not used by another program.
# Short of coming up with a way to check whether the Worksheetify is
#  properly running, just trying to run it (and ignoring if it crashes
#  because the port is already is in use) should work.
wsfy_cmd = vim.eval("l:cmd")
start_server(wsfy_cmd)


wsfy_port = int(vim.eval("g:cworksheetify_server_port"))
c_src_filename = vim.eval("l:cSrcFilename")
c_src = "\n".join(vim.current.buffer[:])

# Send to server,
# get result back (as list of lists).
# wsfy_results = run_worksheetify_client("localhost", wsfy_port, c_src_filename)
wsfy_results = run_worksheetify_client_with_text("localhost", wsfy_port, c_src)


# `wsfy_results` is list of raw strings;
# `wsfy_output` assumed to be **spaces + comments + result**.
col_for_ws = 50
wsfy_output = with_spaces_and_comments(vim.current.buffer[:], wsfy_results, col_for_ws)

EOF

    " Assumes Python 2.x
    let ws_output = pyeval("wsfy_output")

    " Each enter in `ws_output` corresponds to output to
    "  append-to the line.
    " Being from line 1.
    let currLine = 1
    for output in ws_output
        " Append to cursor position
        call append(currLine, output)

        " Worksheetify assumes that the first string of result is
        " appended to the *same* line. So, we join the currentLine with the
        " next.
        if len(output) > 0
            execute (currLine) . "j!"
        endif

        " The next line to append to. Increase by at least 1.
        let currLine = currLine + max([1, len(output)])
    endfor
endfunction
