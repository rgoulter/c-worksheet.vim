# C Worksheet (for Vim)

Plugin for Vim to make use of the C worksheet tool<sup>[1](#myfootnote1)</sup>.

![demo](https://github.com/rgoulter/c-worksheet.vim/raw/master/demo.gif)

[(Here is the same gif, slower speed).](https://github.com/rgoulter/c-worksheet.vim/raw/master/demo-slow.gif)

First execution may be a bit slow, but it should be quicker to 'worksheetify'
subsequently.

Works with Vundle, so can be installed with:

```
Plugin 'rgoulter/c-worksheet.vim'
```

The plugin relies on a companion third-party tool, which the plugin will
**automatically download** if it can't otherwise find it. (It will be
downloaded into `<plugin_dir/tool>`).

## Requirements

This plugin requires Python 2. Vim needs the `python` option. i.e.
`:echo has('python')` needs to evaluate to true (`1`).

The C worksheet tool requires GCC on `PATH`, and an installation of some JRE.
(See
[rgoulter/c-worksheet-instrumentor#requirements](https://github.com/rgoulter/c-worksheet-instrumentor#requirements)).

## Commands

This plugin provides two commands:

| Key Sequence               | Action                                                              |
| ---------------------------| --------------------------------------------------------------------|
| `CWorksheetEvaluate`       | Evaluate Worksheet. (Clear Worksheet, Save, Evalute Results, Save). |
| `CWorksheetClear`          | Clear Worksheet. (Clear Worksheet, Save).                           |

This functionality is available without the saving via functions
`cworksheet#CWorksheetClear()`, `cworksheet#CWorksheetEvaluate()`.

## Key Bindings

| Key Sequence               | Action                              |
| ---------------------------| ------------------------------------|
| `<leader>w` (`\w` default) | Evaluate Worksheet                  |
| `<leader>e` (`\e` default) | Clear Worksheet                     |

## Options

### g:cworksheet_no_conceal
The worksheet outputs `//>`, `//|` as symbols to denote worksheet output.
If `g:cworksheetify_server_command` is not set to `1` (default `0`), then they
will be 'concealed' (and appear as) `>`, `|` instead.  
This makes use of the 'concealed characters' feature in Vim. The C file will
still contain `//>`, `//|` for the comments.

### g:cworksheetify_server_command
With a [release of C-Worksheet](https://github.com/rgoulter/c-worksheet-instrumentor/releases),
unzipped at some path at `path/to/c-worksheet-instrumentor`,  
it should work with this plugin on vim's runtime path, and setting
`g:cworksheetify_server_command` appropriately. e.g.:

```
set rtp+=/home/richard/.vim/cworksheet/

let g:cworksheetify_server_command = "/path/to/c-worksheet-instrumentor/bin/c-worksheetify-server"
```

(where `$HOME/.vim/cworksheet` is this repository).

## Evaluate-Worksheet-on-Save

It may be more convenient to setup so that the worksheet evaluates each time
the file is saved. This can be achieved using an `autocmd`, like:

```
autocmd BufWrite *.c call cworksheet#CWorksheetClear() | call cworksheet#CWorksheetEvaluate()
```

* * *

<a name="myfootnote1">1</a>:
[rgoulter/c-worksheet-instrumentor](https://github.com/rgoulter/c-worksheet-instrumentor)
