# C Worksheet (for Vim)

Plugin for Vim to make use of the [C
worksheet](https://github.com/rgoulter/c-worksheet-instrumentor) tool.  
This plugin assumes `g:cworksheetify_server_command` is either set to the
filepath to the appropriate script under `bin/`, or those scripts are on the
`PATH`.

At the moment, has only the keybindings: `<leader>w`, `<leader>e`, which
evaluate and clear, respectively.

First execution may be a bit slow, but it should be quicker to 'worksheetify'
subsequently.

## Getting it to Work

With a [release of C-Worksheet](https://github.com/rgoulter/c-worksheet-instrumentor/releases),
unzipped at some path at `path/to/c-worksheet-instrumentor`,  
it should work with this plugin on vim's runtime path, and setting
`g:cworksheetify_server_command` appropriately. e.g.:

```
set rtp+=/home/richard/.vim/cworksheet/

let g:cworksheetify_server_command = "/path/to/c-worksheet-instrumentor/bin/c-worksheetify-server"
```

(where `$HOME/.vim/cworksheet` is this repository).
