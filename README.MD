# C Worksheet (for Vim)

Plugin for Vim to make use of the [C
worksheet](https://github.com/rgoulter/c-worksheet-instrumentor) tool.  
This plugin assumes `g:cworksheet_command` is either set to the filepath to the
appropriate script under `bin/`, or those scripts are on the `PATH`.

At the moment, has only the keybindings: `<leader>w`, `<leader>e`, which
evaluate and clear, respectively.

At the moment, the executable is *a bit* slow. Yay, JVM. :-)  
Will work on this.

Other improvements to make to this plugin, depending on the Worksheetify
program above,
