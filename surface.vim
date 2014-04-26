let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
cnoremap <C-F4> c
inoremap <C-F4> c
cnoremap <C-Tab> w
inoremap <C-Tab> w
cmap <S-Insert> +
imap <F5> :r !date /T:r !time /To
imap <S-Insert> 
xnoremap  ggVG
snoremap  gggHG
onoremap  gggHG
nnoremap  gggHG
vnoremap  "+y
noremap  
nnoremap  :update
vnoremap  :update
onoremap  :update
nmap  "+gP
omap  "+gP
vnoremap  "+x
noremap  
noremap  u
cnoremap   :simalt ~
inoremap   :simalt ~
inoremap Â  :simalt ~
cnoremap Â  :simalt ~
map Q gq
map <silent> \t :call MakeGreen()
nmap gx <Plug>NetrwBrowseX
nnoremap <C-F4> c
nnoremap <C-Tab> w
nmap <S-Insert> "+gP
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
onoremap <C-F4> c
vnoremap <C-F4> c
onoremap <C-Tab> w
vnoremap <C-Tab> w
vmap <S-Insert> 
vnoremap <BS> d
map <F5> :r !date /T:r !time /To
vmap <C-Del> "*d
vnoremap <S-Del> "+x
vnoremap <C-Insert> "+y
omap <S-Insert> "+gP
cnoremap  gggHG
inoremap  gggHG
inoremap  :update
inoremap  u
cmap  +
inoremap  
inoremap  u
noremap   :simalt ~
noremap Â  :simalt ~
let &cpo=s:cpo_save
unlet s:cpo_save
set backspace=indent,eol,start
set backup
set diffexpr=MyDiff()
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1
set guifont=SimHei:h14:cANSI
set helplang=En
set history=50
set hlsearch
set ignorecase
set incsearch
set keymodel=startsel,stopsel
set ruler
set selection=exclusive
set selectmode=mouse,key
set noswapfile
set whichwrap=b,s,,,,,,,,,<,>,[,]
set window=21
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd C:\archive\flash\surface
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +3 \project\ethan\todo.txt
badd +1722 \project\ethan\2011.txt
badd +2 \project\ethan\reading\ list\ 2007-10-191.txt
badd +4663 \project\mmorpg\worldofwarcraft.txt
badd +8 \project\globex\notes.txt
badd +1965 \project\computer\computer.txt
badd +1 \project\ethan\game\ 2008-01-11.txt
badd +9 \Users\Ethan\_vimrc
badd +1 \project\globex\sko.txt
badd +6 \project\ethan\shopping_2009-05-19.txt
badd +52 \project\ethan\project.txt
badd +364 \project\china\china.txt
badd +1 \Program\ Files\ (x86)\Vim\vim73\mswin.vim
badd +463 \project\china\chinese.txt
badd +14560 \project\ethan\cook_2009-08-15.txt
badd +1787 \project\ethan\job_2011.txt
badd +1642 \archive\amsterdam\amsterdam2009-06.txt
badd +1033 \archive\ethan\health.txt
badd +1 \project\computer\debugging.txt
badd +576 \project\ethan\2012.txt
badd +309 \project\ethan\san-francisco.txt
badd +235 \project\game_tools\game_tools.txt
badd +26 \project\ethan\murfreesboro.txt
badd +179 \project\ethan\jade.txt
badd +12 \project\ethan\raleigh.txt
badd +1 \project\ethan\matthew_bike.txt
badd +145 \project\ethan\home.txt
badd +37 \project\ethan\bike.txt
badd +13 \project\ethan\hostgator.txt
badd +6 \Users\Ethan\vimfiles\ftplugin\python_kennerly.vim
badd +6 \Users\Ethan\vimfiles\compiler\python.vim
badd +1 \project\stocksurfer\stocksurfer.txt
badd +24 \project\ethan\religion.txt
badd +70 \project\ethan\politics.txt
badd +145 \project\computer\javascript.txt
badd +46 \project\computer\flash.txt
badd +181 \project\ethan\life_invaders.txt
badd +108 \archive\flash\actionscript.txt
badd +118 \project\ethan\coconut_curry_in_a_pumpkin.txt
badd +75 \project\ethan\flash.txt
badd +55 \archive\android\android.txt
badd +9994 \project\ethan\2013.txt
badd +13 \project\ethan\aaron.txt
badd +603 \project\ethan\health_2013.txt
badd +4 \Users\Ethan\Documents\personal\mundane\banking\mcalpin.txt
badd +88 \archive\findthefun\kennerly_bit_of_fun.txt
badd +1361 \project\ethan\music_pandora_likes.txt
badd +51 \project\ethan\music_rdio.txt
badd +78 \project\ethan\sailing.txt
badd +15 \project\ethan\sf.txt
badd +16 \project\ethan\finance.txt
badd +677 \project\ethan\game\ list\ 2005-10-04.txt
badd +53 \project\ethan\2014.txt
badd +1 \archive\flash\wedding-cake-builder\notes.txt
badd +0 notes.txt
silent! argdel *
edit notes.txt
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal balloonexpr=
setlocal nobinary
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != ''
setlocal filetype=
endif
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
set foldmethod=indent
setlocal foldmethod=indent
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal grepprg=
setlocal iminsert=2
setlocal imsearch=2
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal nolist
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=8
setlocal noshortname
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=
setlocal suffixesadd=
setlocal noswapfile
setlocal synmaxcol=3000
if &syntax != ''
setlocal syntax=
endif
setlocal tabstop=8
setlocal tags=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
36
normal zo
91
normal zo
let s:l = 88 - ((22 * winheight(0) + 16) / 33)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
88
normal! 088l
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
