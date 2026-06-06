" .vimrc written by nbisco

" bellを全部止める
set belloff=all

" 補完時のpreviewを出さない
set completeopt=menuone

" vi互換をoff
set nocompatible

" 色
syntax on
set background=dark

" 行番号
set number

" タブ設定
set tabstop=4
set expandtab
set showcmd
set shiftwidth=4
set list
set listchars=tab:>\ ,trail:.
hi SpecialKey ctermfg=darkgrey

" インデント
set autoindent
set smartindent

" case ignoreで検索
set ignorecase

" 複数ファイル編集可能にする
set hidden

" かっこのハイライト
set showmatch
set matchtime=2

" INSERT / REPLACE を表示
set showmode

" ステータスライン(適当)
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ENC=%{&fileencoding}]\ [POS=%04l/%04L,%04v][%p%%]
set laststatus=2
highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=black ctermbg=cyan cterm=none

" 内容変更は自動再読み込み
set autoread

" 起動時のメッセージは表示しない
set shortmess+=I

" 検索結果をハイライトする
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" インクリメンタルサーチ
set incsearch

" 末尾まで検索したら先頭に戻る
set wrapscan

" 大文字混じりのときは大文字小文字区別して検索する
set smartcase

" エラーベルは目障りなので消す
set noerrorbells

" バックアップファイルは作らない
set nobackup

" backspaceでもろもろ消せるようにする
set backspace=indent,eol,start

" コマンド補完
set wildmenu
set wildchar=<tab>

" 検索語が画面中央に来る
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"表示行単位で行移動する
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" 行頭/行末だけはemacsっぽく
inoremap <silent> <C-a> <Esc>0<Insert>
inoremap <silent> <C-e> <Esc>$a

augroup MyAutoCmd
    autocmd!
augroup END

"JS
autocmd BufNewFile,BufRead *.js  set tabstop=2 shiftwidth=2 expandtab

""JSON
autocmd BufNewFile,BufRead *.json  set filetype=json
autocmd BufNewFile,BufRead *.json  set tabstop=2 shiftwidth=2 expandtab

"Jade
autocmd BufNewFile,BufRead *.jade  setf jade
autocmd BufNewFile,BufRead *.jade  set tabstop=2 shiftwidth=2 expandtab

"stylus
autocmd BufNewFile,BufRead *.styl  setf stylus
autocmd BufNewFile,BufRead *.styl  set tabstop=2 shiftwidth=2 expandtab

" coffeescript
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
" インデント設定
autocmd FileType coffee    setlocal sw=2 sts=2 ts=2 et

"Makefile
autocmd BufNewFile,BufRead Makefile  setf Make
autocmd BufNewFile,BufRead Makefile  set tabstop=4 shiftwidth=4 noet

"*.fish
autocmd BufNewFile,BufRead *.fish  setf sh
autocmd BufNewFile,BufRead *.fish  set tabstop=4 shiftwidth=4 et

" 文字コードとか
set fileformats=unix,dos,mac
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" □とか○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.binファイルを開くと発動）
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r
    autocmd BufWritePre * endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END


" make、grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" xmlの閉じタグを勝手に書く
set omnifunc=xmlcomplete#CompleteTags
augroup MyXML
    autocmd!
    autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

command Kernel set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
