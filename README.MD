# C Worksheet (for Vim)

Plugin for Vim to make use of the C worksheet tool<sup>[1](#myfootnote1)</sup>.

![demo](https://github.com/rgoulter/c-worksheet.vim/raw/master/demo.gif)

[(Here is the same gif, slower speed).](https://github.com/rgoulter/c-worksheet.vim/raw/master/demo-slow.gif)

Or see the [examples in the c-worksheet-instrumentor
readme](https://github.com/rgoulter/c-worksheet-instrumentor/?tab=readme-ov-file#worksheet-examples).

## Installation

Can be installed with Vundle:

```
Plugin 'rgoulter/c-worksheet.vim'
```

or clone this repository, and add the directory to vim's runtimepath, e.g. in `.vimrc`:

```
set rtp+=/path/to/.vim/cworksheet.vim/
```

## Requirements

This plugin requires:

- Python 3,
- Vim needs the `python3` option. i.e. `:echo has('python3')` needs to evaluate to true (`1`),
- [rgoulter/c-worksheet-instrumentor](https://github.com/rgoulter/c-worksheet-instrumentor).

The C worksheet tool requires GCC or Clang on `PATH`.

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

Defaults to `c-worksheetify-server`.

Can be explicitly set to a particular installation of `c-worksheetify-server`.

```
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
