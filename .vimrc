" -----
" 基本設定などなど
" -----
" カラースキーム
if has('mac')
  colorscheme jellybeans
endif
" 行番号表示
set number
" 長い文章の自動折り返しをしない(テキストなんかはこれで)
set textwidth=0
" タブを常に表示
set showtabline=2
" タブ幅4
set tabstop=4
set softtabstop=0
" ビープ音抑止
set vb t_vb=
" vimを使ってくれて(ry 表示しない
set notitle
" 現在のモードを表示
set showmode
" カーソルを行頭、行末で止まらないようにする
set nocompatible
set whichwrap=b,s,h,l,<,>,[,]
" 常にステータス行を表示
set laststatus=2
" コマンドをステータス行に表示
set showcmd
" スワップファイルを作成しない
set noswapfile
" Undo回数変更
set undolevels=2000
" 構文色分け
syntax on
" タブ文字可視可
set list
set listchars=tab:>-
" デフォルトvimrc_exampleのtextwidth設定上書き
autocmd FileType text setlocal textwidth=0

" ','置き換え
let mapleader = ","

" Windowsの場合、バックアップファイル・スワップファイルのディレクトリを指定
if has('win32') || has('win64')
  set backupdir=~/gvim/backup
  set directory=~/gvim/swap
" 他の環境では、バックアップファイル・スワップファイルは作成しない
else
  set nobackup
  set noswapfile
endif

"ヘルプ
nnoremap <F1> K
" 現在開いているvimスクリプトファイルを実行
nnoremap <F8> :source %<CR>
" 強制全保存終了を無効化
nnoremap ZZ <Nop>

" 全角スペースをハイライト表示させる
" ひとまずWindowsとMac他で別設定にしておく
if has('win32') || has('win64')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * highlight ZenkakuSpace term=underline ctermbg=Red guibg=Red
    " %u3000は全角スペースの文字コード
    autocmd VimEnter,WinEnter * match ZenkakuSpace /\%u3000/
  augroup END
else
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
  match ZenkakuSpace /\%u3000/
endif

" ステータスラインに文字コードやBOM、16進表示等表示
" iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にするFencB()を使用
if has('iconv')
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=[0x%{FencB()}]\ (%v,%l)/%L%8P\ 
else
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=\ (%v,%l)/%L%8P\ 
endif

function! FencB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return s:Byte2hex(s:Str2byte(c))
endfunction

function! s:Str2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction

" -----
" 編集系設定
" -----
" <C-a><C-x>の文字列認識を変更(07などを8進数とみなさない)
set nrformats=""
" オートインデント
set autoindent
" タブをスペース展開
set expandtab
" 他で書き換えられたら読み直す
set autoread
" バックスペースでなんでも(改行も)消せるように
set backspace=indent,eol,start
" タブ文字入力によるタブ幅をスペース4つぶんに
set shiftwidth=4
" 縦に連番を入力する
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor
" 横分割時は下へ､ 縦分割時は右へ新しいウィンドウが開くようにする
set splitbelow
set splitright

" -----
" 検索に関する設定
" -----
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" インクリメンタルサーチ
set incsearch
" Esc2回押しでハイライト解除
nmap <Esc><Esc> :nohlsearch<CR>
" 検索後、その行を中央に表示
nmap n nzz
nmap N Nzz
" タブ新規作成
nmap tn :tabnew<CR>
 
" -----
" エンコード設定
" -----
" エンコード設定 常時UTF-8
set encoding=utf-8
" ファイル保存エンコーディングをUTF-8に指定する
set fenc=utf-8

" OSのクリップボードを使用する
set clipboard+=unnamed
" 挿入モードで<C-p>を押すとクリップボードの内容をペースト
" imap <C-p> <ESC>"*pa

" -----
" Vundleによるプラグイン管理
" -----
filetype off

if has('win32') || has('win64')
  " TODO windows対応
  "" 相対パスにしておく(Windowsで'~'はC:\Users\になる)
  "set rtp+=./vimfiles/vundle.git/
  "" プラグインはvimfiles/bundle/以下で管理
  "call vundle#rc('./vimfiles/bundle/')
else
  set rtp+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/vim_plugins/'))
endif

" Scalaコードの設定etc
NeoBundle 'rosstimson/scala-vim-support'
" 補完プラグイン
NeoBundle 'Shougo/neocomplete'

NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'

" プログラム実行
NeoBundle 'thinca/vim-quickrun'
" テキスト括弧etc補完
NeoBundle 'surround.vim'
" Vimからack検索
NeoBundle 'mileszs/ack.vim'
" 行先頭に連番挿入
NeoBundle 'catn.vim'
" コメント挿入プラグイン
NeoBundle 'scrooloose/nerdcommenter'
" <C-a><C-n>で月、曜日などをインクリメント/デクリメント(monday.vimの改変版)
NeoBundle 'nishigori/vim-sunday'
" Haxe用プラグイン
NeoBundle 'jdonaldson/vaxe'
" ファイル検索プラグイン
NeoBundle 'ctrlp.vim'
" ステータスライン色づけ
NeoBundle 'itchyny/lightline.vim'
" 統合UI
NeoBundle 'Shougo/unite.vim'
" 一括置換ハイライト
NeoBundle 'osyo-manga/vim-over'

" sudo実行(macのみに適用)
if has('mac')
    NeoBundle 'sudo.vim'
endif

filetype plugin indent on

" neocomplcache
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#dictionary_filetype_lists = {
  \ 'default' : '',
  \ 'scala' : $HOME . '/.vim/dict/scala.dict',
  \ }

" RSence
" Windowsだとうまく動かせないので現状Macだけにしておく
"if has('mac')
"  if !exists('g:neocomplete#omni_patterns')
"    let g:neocomplete#omni_patterns = {}
"  endif
"  let g:rsenseUseOmniFunc = 1
"  if filereadable(expand('~/lib/rsense-0.3/bin/rsense'))
"    let g:rsenseHome = expand('~/lib/rsense-0.3')
"    let g:neocomplete#omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"  endif
"endif

" quickrun
" 横分割をするようにする
let g:quickrun_config={'*': {'split': ''}}

" surround
" 'g':「」でくくる
let g:surround_103 = "「\r」"

" nerdcommenter
" コメント後のスペース数
let NERDSpaceDelims = 1

" overvim
" over.vimの起動 ,m
nnoremap <silent> <Leader>m :OverCommandLine<CR>
" カーソル下の単語をハイライト付きで置換
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
" コピーした文字列をハイライト付きで置換
nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>

" -----
" FileType設定
" -----
augroup MyAutoCmdFileType
  autocmd! MyAutoCmdFileType 
  autocmd BufRead,BufNewFile *.scala set filetype=scala
augroup END
