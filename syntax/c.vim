if exists('g:cworksheet_no_conceal') || !has('conceal')
    finish
endif

" Conceal //>, //| with >, | respectively.
syntax match cworksheetOutput "\/\/>" conceal cchar=>
syntax match cworksheetOutput "\/\/|" conceal cchar=|

" Ensure that the concealed characters get hidden,
" in normal/visual/command modes.
setlocal conceallevel=2
setlocal concealcursor+=n
setlocal concealcursor+=v
setlocal concealcursor+=c
