call plug#begin('~/.vim/plugged')

" テーマ
Plug 'cocopon/iceberg.vim'

Plug 'mattn/vim-findroot'

" ファジーファインダー
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

" 括弧系の自動挿入
Plug 'jiangmiao/auto-pairs'

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

" git
Plug 'tpope/vim-fugitive'

" quickrun
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-quickrun'

" visualモードで * で検索
Plug 'thinca/vim-visualstar'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'

" 言語系
Plug 'rust-lang/rust.vim'
Plug 'keith/swift.vim'

Plug 'nathanaelkane/vim-indent-guides'

Plug 'junegunn/vim-easy-align'

Plug 'tyru/open-browser.vim'

Plug 'thinca/vim-localrc'

" flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" toggle
Plug 'lukelbd/vim-toggle'

call plug#end()

function! CocInstall()
  CocInstall coc-json
  CocInstall coc-tsserver
  CocInstall coc-eslint
  CocInstall coc-fzf-preview
  CocInstall coc-rls
  CocInstall coc-explorer
  CocInstall coc-flutter
  CocInstall coc-sourcekit
endfunction

syntax on
filetype plugin indent on

" https://vimcolorschemes.com/christianchiarulli/nvcode-color-schemes.vim
set background=dark
colorscheme onedark

" 自動再読み込み
set autoread

set hidden

" 改行文字などの表示
set list
set listchars=tab:¦\ ,eol:↴,trail:-,nbsp:%,extends:>,precedes:<
set fillchars=vert:\ ,fold:\ ,diff:\

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

" 行末に ; , を追加
nnoremap <expr> <space>; getline('.')[col('$') - 2] == ';' ? "" : 'A;<Esc>'
nnoremap <expr> <space>, getline('.')[col('$') - 2] == ',' ? "" : 'A,<Esc>'

" 行を詰めずに削除
nnoremap <Space>d cc<ESC>

" vimrc の編集・リロード
nnoremap <silent> <Space>.. :<C-u>edit ~/.vimrc<CR>
nnoremap <silent> <Space>.e :<C-u>edit ~/.vimrc<CR>
nnoremap <silent> <Space>.s :<C-u>split ~/.vimrc<CR>
nnoremap <silent> <Space>.v :<C-u>vsplit ~/.vimrc<CR>
nnoremap <silent> <Space>.r :<C-u>source ~/.vimrc<CR>
nnoremap <silent> <Space>.i :<C-u>PlugInstall<CR>:call CocInstall()<CR>
nnoremap <silent> <Space>.l :<C-u>edit .local.vimrc<CR>

" メモファイル
command! -nargs=1 -complete=filetype Temp edit ~/.vim_tmp/tmp.<args>
command! Memo edit ~/Dropbox/Memo/memo.md
command! Inbox edit .inbox.md

" TODOの挿入・トグル
function! ToggleCheckbox()
  let l:line = getline('.')
  if l:line =~ '^\-\s\[\s\]'
    let l:result = substitute(l:line, '^-\s\[\s\]', '- [x]', '')
    call setline('.', l:result)
  elseif l:line =~ '^\-\s\[x\]'
    let l:result = substitute(l:line, '^-\s\[x\]', '- [ ]', '')
    call setline('.', l:result)
  end
endfunction
nnoremap <space>ti I- [ ]
nnoremap <space>tt :call ToggleCheckbox()<CR>

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif
  execute "%! cat % | jq \"" . l:arg . "\""
endfunction

function! HasPlugin(name)
  return globpath(&runtimepath, 'plugin/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'autoload/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'colors/' . a:name . '.vim') !=# ''
endfunction

if HasPlugin('fzf-preview')
  set shell=/bin/zsh
  let $SHELL = "/bin/zsh"

  " unite を使っていた名残で u をprefix に
  nnoremap <silent> <leader>uf :<C-u>CocCommand fzf-preview.ProjectFiles<CR>
  nnoremap <silent> <leader>um :<C-u>CocCommand fzf-preview.ProjectMruFiles<CR>
  nnoremap <silent> <leader>uM :<C-u>CocCommand fzf-preview.MruFiles<CR>
  nnoremap <silent> <leader>ug :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
  nnoremap <silent> <leader>ub :<C-u>CocCommand fzf-preview.AllBuffers<CR>

  " git系
  nnoremap <silent> <leader>gs :<C-u>CocCommand fzf-preview.GitStatus<CR>
  nnoremap <silent> <leader>ga :<C-u>CocCommand fzf-preview.GitActions<CR>
  nnoremap <silent> <leader>gb :<C-u>CocCommand fzf-preview.GitBranches<CR>
  nnoremap <silent> <leader>gl :<C-u>CocCommand fzf-preview.GitLogs<CR>
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
  map <leader>c <Plug>(operator-camelize)
  map <leader>C <Plug>(operator-decamelize)

  " 置換
  vmap p <Plug>(operator-replace)
  map R <Plug>(operator-replace)
endif

if HasPlugin('coc.nvim')
  " enter で選択
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gR <Plug>(coc-rename)
  nnoremap <silent> gh :<C-u>call CocAction('doHover')<CR>
  nnoremap <silent> gl :<C-u>CocList<CR>

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  nnoremap <leader>f :<C-u>CocCommand explorer<CR>
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

if HasPlugin('rust')
  let g:rustfmt_autosave = 1
  let g:rust_clip_command = 'pbcopy'
endif

if HasPlugin('vim-quickrun')
  let g:quickrun_config = {
  \   "_" : {
  \     "outputter/buffer/split" : ":botright",
  \     "runner" : "vimproc"
  \   },
  \   'rust': {
  \     'exec' : 'cargo run'
  \   }
  \}
endif

if HasPlugin('openbrowser')
  nmap <silent> <leader>o <Plug>(openbrowser-open)
endif

set iskeyword+=$

let g:indent_guides_enable_on_vim_startup = 1

let g:toggle_map = "<Leader>t"

" ファイルをひらいたときに最後にカーソルがあった場所に移動する
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

" ファイルタイプ別の設定を読み込む
augroup vimrc
  autocmd!
  autocmd Filetype * call s:filetype(expand('<amatch>'))
augroup END
function! s:filetype(ftype) abort
  if !empty(a:ftype) && exists('*' . 's:filetype_' . a:ftype)
    execute 'call s:filetype_' . a:ftype . '()'
  endif
endfunction

function! s:filetype_php() abort
  setlocal shiftwidth=2
  setlocal tabstop=2
  setlocal softtabstop=2
  setlocal noexpandtab

  set commentstring=//%s
endfunction


function! s:filetype_dart() abort
  nnoremap <leader>r <Nop>
  nnoremap <leader>rr :<C-u>FlutterRun<CR>
  nnoremap <leader>rq :<C-u>FlutterQuit<CR>
endfunction

" :TSInstall maintained
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  ensure_installed = 'maintained'
}
EOF

let g:nvcode_termcolors=256
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
