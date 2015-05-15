# C Worksheet (for Vim)

Plugin for Vim to make use of the [C
worksheet](https://github.com/rgoulter/c-worksheet-instrumentor) tool.  
This plugin assumes `g:cworksheetify_server_command` is either set to the
filepath to the appropriate script under `bin/`, or a distribution of the tool
exists under `<plugin_dir>/tool/`.  
This plugin will download & unzip the latest release from
added`rgoulter/c-worksheet-instrumentor` into `<plugin_dir>/tool` if it can't find
`c-worksheetify-server`. (It checks this when Vim opens a C file, e.g. `:e
somefile.c`).

First execution may be a bit slow, but it should be quicker to 'worksheetify'
subsequently.

Works with Vundle, so can be installed with:

```
Plugin 'rgoulter/c-worksheet.vim'
```

## Requirements

This plugin requires Python 2. Vim needs the `python` option. i.e.
`:echo has('python')` needs to evaluate to true (`1`).

The C worksheet tool requires GCC on `PATH`, and an installation of some JRE.
(See
[rgoulter/c-worksheet-instrumentor#requirements](https://github.com/rgoulter/c-worksheet-instrumentor#requirements)).

## Key Bindings

| Key Sequence               | Action                              |
| ---------------------------| ------------------------------------|
| `<leader>w` (`\w` default) | Evaluate Worksheet                  |
| `<leader>e` (`\e` default) | Clear Worksheet                     |

## Options

With a [release of C-Worksheet](https://github.com/rgoulter/c-worksheet-instrumentor/releases),
unzipped at some path at `path/to/c-worksheet-instrumentor`,  
it should work with this plugin on vim's runtime path, and setting
`g:cworksheetify_server_command` appropriately. e.g.:

```
set rtp+=/home/richard/.vim/cworksheet/

let g:cworksheetify_server_command = "/path/to/c-worksheet-instrumentor/bin/c-worksheetify-server"
```

(where `$HOME/.vim/cworksheet` is this repository).
