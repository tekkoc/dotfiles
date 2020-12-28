call plug#begin('~/.vim/plugged')

" テーマ
Plug 'cocopon/iceberg.vim'

Plug 'mattn/vim-findroot'

" ファジーファインダー
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

" textobj
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'

" operator
Plug 'kana/vim-operator-user'
Plug 'tyru/operator-camelize.vim'
Plug 'kana/vim-operator-replace'
Plug 'emonkak/vim-operator-comment'

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ハイライト
Plug 'sheerun/vim-polyglot'

" status line
Plug 'itchyny/lightline.vim'

" linter
Plug 'dense-analysis/ale'

" gitで差分がある行の表示
Plug 'mhinz/vim-signify'

" インサートモード時に行を反転
Plug 'cohama/vim-insert-linenr'

" コマンドライン補完
Plug 'thinca/vim-ambicmd'

call plug#end()

syntax on
filetype plugin indent on

" 自動再読み込み
set autoread

" 各種ファイルを生成しない
set nobackup
set nowritebackup
set noswapfile
set noundofile

" カーソル行を常に中央に
set scrolloff=999

" 現在行と相対行を表示
set number
set relativenumber

" タブ・インデント設定
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" 検索設定
set ignorecase
set smartcase
set wrapscan
set incsearch

" ヤンクしたものをクリップボードにも
set clipboard=unnamed

" コロンとセミコロンを入れ替え
noremap : ;
noremap ; :

let mapleader =","

" <C-l>でEscする
vnoremap <C-l> <Esc>
inoremap <C-l> <Esc>
cnoremap <C-l> <C-c>
nnoremap <C-l> <Esc>

" シフトで多めに移動
nnoremap <silent> J 10j
nnoremap <silent> K 10k
nnoremap <silent> L 10l
nnoremap <silent> H 10h
vnoremap J 10j
vnoremap K 10k
vnoremap L 10l
vnoremap H 10h

" space+w で保存 space+W で全保存
nnoremap <space>w :<C-u>w<CR>
nnoremap <space>W :<C-u>wa<CR>

" sをprefixに分割・タブページ関連を割り当てる
nnoremap s <Nop>

" ss sv で分割
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>

" s+hjkl で分割ウィンドウ間を移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h

" s+HJKL で分割画面を移動
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H

" タブページを作成
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>

" タブページを移動
nnoremap sn gt
nnoremap sp gT
nnoremap sN :<C-u>tabmove +1<CR>
nnoremap sP :<C-u>tabmove -1<CR>

" バッファを閉じる
nnoremap sq :<C-u>q<CR>

" キーボードマクロをQに降格
nnoremap q <Nop>
nnoremap Q q

" ノーマルモード時に改行
nnoremap <CR> o<Esc>

" 行を詰めずに削除
nnoremap <Space>d cc<ESC>

" vimrc の編集・リロード
nnoremap <silent> <Space>. :<C-u>edit ~/.vimrc<CR>
command! Reload source ~/.vimrc

function! HasPlugin(name)
  return globpath(&runtimepath, 'plugin/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'autoload/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'colors/' . a:name . '.vim') !=# ''
endfunction

if HasPlugin('iceberg')
  colorscheme iceberg
  set background=dark
endif

if HasPlugin('fzf-preview')
  " unite を使っていた名残で u をprefix に
  nnoremap <silent> <leader>uf :<C-u>FzfPreviewProjectFiles<CR>
  nnoremap <silent> <leader>um :<C-u>FzfPreviewMruFiles<CR>
endif

if HasPlugin('findroot')
  let g:findroot_patterns = [
  \  '.git/',
  \  '.svn/',
  \  '.hg/',
  \  '.bzr/',
  \  '.gitignore',
  \  'Rakefile',
  \  'pom.xml',
  \  'project.clj',
  \  '*.csproj',
  \  '*.sln',
  \]
endif

if HasPlugin('vim-operator-user')
  " コメント
  map C <Plug>(operator-comment)
  map X <Plug>(operator-uncomment)
  set commentstring=//%s

  " camelize
  map <Leader>c <Plug>(operator-camelize)
  map <Leader>C <Plug>(operator-decamelize)

  " 置換
  vmap p <Plug>(operator-replace)
  map R <Plug>(operator-replace)
endif

function! CocInstall()
  CocInstall coc-json
  CocInstall coc-tsserver
  CocInstall coc-eslint
endfunction

if HasPlugin('coc.nvim')
  " enter で選択
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
endif

if HasPlugin('lightline')
  let g:lightline = {
        \ 'colorscheme': 'iceberg'
        \ }
endif

if HasPlugin('ale')
  let g:ale_fix_on_save = 1
  let g:ale_fixers = {
        \ '*': ['remove_trailing_lines', 'trim_whitespace'],
        \}
endif

if HasPlugin('ambicmd')
  cnoremap <expr> <Space> ambicmd#expand("\<Space>")
  cnoremap <expr> <CR>    ambicmd#expand("\<CR>")
endif
