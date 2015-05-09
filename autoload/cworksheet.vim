function! cworksheet#CWorksheetClear()
    " Remove all matches of the regex:
    "   \s*\/\/>.*\(\n\s*\/\/|.*\)*
    " i.e. all spaces leading up to //> and to EOL,
    "  as well as any blank lines leading up to //| and to EOL.
    execute "silent! %s/\\s*\\/\\/>.*\\(\\n\\s*\\/\\/|.*\\)*//"
endfunction


" Need this function for when this plugin has additional flags to
" pass to the cworksheet program.
function! cworksheet#CWorksheetCommand()
    return g:cworksheet_command
endfunction


" Load helper.py from same directory as this script.
"
" helper.py has some functions which can
" distinguish output from a worksheet.
"
" output = reduce(acc_worksheet_output, lines, [])
execute "pyfile " . expand("<sfile>:h") . "/helper.py"


function! cworksheet#CWorksheetEvaluate()
    let cmd = cworksheet#CWorksheetCommand()

    " Full path of current file/buffer.
    let f = expand("%:p")

    let wsfy_str = system(cmd . " " . f)
    let wsfy_lines = split(wsfy_str, "\n")

    python << EOF
import vim

def vim_worksheetify():
    wsfy_lines = vim.eval("l:wsfy_lines")
    ws_output = reduce(acc_worksheet_output, wsfy_lines, [])
    return ws_output
EOF

    " Assumes Python 2.x
    let ws_output = pyeval("vim_worksheetify()")

    " Each enter in `ws_output` corresponds to output to
    "  append-to the line.
    " Being from line 1.
    let currLine = 1
    for output in ws_output
        " Append to cursor position
        call append(currLine + 1, output)

        " Worksheetify assumes that the first string of result is
        " appended to the *same* line. So, we join the currentLine with the
        " next.
        if len(output) > 0
            execute (currLine + 1) . "j!"
        endif

        " The next line to append to. Increase by at least 1.
        let currLine = currLine + max([1, len(output)])
    endfor
endfunction
