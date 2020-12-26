call plug#begin('~/.vim/plugged')

" テーマ
Plug 'cocopon/iceberg.vim'

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

" ヤンクしたものをクリップボードにも
set clipboard=unnamed

" コロンとセミコロンを入れ替え
noremap : ;
noremap ; :

" <C-l>でEscする
vnoremap <C-l> <Esc>
inoremap <C-l> <Esc>
cnoremap <C-l> <C-c>
nnoremap <C-l> <Esc>

" シフトで多めに移動
nnoremap <silent> J 20j
nnoremap <silent> K 20k
nnoremap <silent> L 10l
nnoremap <silent> H 10h
vnoremap J 20j
vnoremap K 20k
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
command! Ev edit ~/.vimrc
command! Rv source ~/.vimrc

function! HasPlugin(name)
  return globpath(&runtimepath, 'plugin/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'autoload/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'colors/' . a:name . '.vim') !=# ''
endfunction

if HasPlugin('iceberg')
  colorscheme iceberg
  set background=dark
endif
