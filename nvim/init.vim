if !exists('g:vscode')
  scriptencoding utf-8
  source ~/.config/nvim/plugins.vim

  " ============================================================================ "
  " ===                           EDITING OPTIONS                            === "
  " ============================================================================ "

  " Remap leader key to ,
  let mapleader=','

  " This will copy the visual selection to the clipboard on Ctrl-C.
  map <C-c> "+y

  " Enable line numbers
  set number

  " Enable relative numbers
  set relativenumber

  " Don't show last command
  set showcmd

  " Yank and paste with the system clipboard
  set clipboard=unnamed

  " Hides buffers instead of closing them
  set hidden

  " === TAB/Space settings === "
  " Insert spaces when TAB is pressed.
  set expandtab

  " Change number of spaces that a <Tab> counts for during editing ops
  set softtabstop=2

  " Indentation amount for < and > commands.
  set shiftwidth=2

  " Don't highlight current cursor line
  set cursorline

  " Disable line/column number in status line
  " Shows up in preview window when airline is disabled if not
  set noruler

  " Only one line for command line
  set cmdheight=1

  " === Completion Settings === "

  " Don't give completion messages like 'match 1 of 2'
  " or 'The only match'
  set shortmess+=c

  com DisableNumber set nonumber norelativenumber

  com EnableNumber set number relativenumber

  compiler fish

  " ============================================================================ "
  " ===                           PLUGIN SETUP                               === "
  " ============================================================================ "

  " Wrap in try/catch to avoid errors on initial install before plugin is available
  " === Denite setup ==="
  " Use ripgrep for searching current directory for files
  " By default, ripgrep will respect rules in .gitignore
  "   --files: Print each file that would be searched (but don't search)
  "   --glob:  Include or exclues files for searching that match the given glob
  "            (aka ignore .git files)
  "
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

  " Use ripgrep in place of "grep"
  call denite#custom#var('grep', 'command', ['rg'])

  " Custom options for ripgrep
  "   --vimgrep:  Show results with every match on it's own line
  "   --hidden:   Search hidden directories and files
  "   --heading:  Show the file name above clusters of matches from each file
  "   --S:        Search case insensitively if the pattern is all lowercase
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

  " call denite#custom#source('grep', 'args', ['', '', '!'])

  " Recommended defaults for ripgrep via Denite docs
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')

  call denite#custom#option('_', 'statusline', v:false)

  " Define mappings
  " autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
          \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
          \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
          \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
          \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
          \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
          \ denite#do_map('toggle_select').'j'
  endfunction

  " Custom options for Denite
  "   auto_resize             - Auto resize the Denite window height automatically.
  "   prompt                  - Customize denite prompt
  "   direction               - Specify Denite window direction as directly below current pane
  "   winminheight            - Specify min height for Denite window
  "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
  "   prompt_highlight        - Specify color of prompt
  "   highlight_matched_char  - Matched characters highlight
  "   highlight_matched_range - matched range highlight
  let s:denite_options = {'default' : {
  \ 'split': 'floating',
  \ 'auto_resize': 1,
  \ 'start_filter': 1,
  \ 'prompt': 'λ:',
  \ 'direction': 'rightbelow',
  \ 'winminheight': '20',
  \ 'highlight_mode_insert': 'Visual',
  \ 'highlight_mode_normal': 'Visual',
  \ 'prompt_highlight': 'Function',
  \ 'highlight_matched_char': 'Function',
  \ 'highlight_matched_range': 'Normal',
  \ 'winrow': 1,
  \ 'vertical_preview': 1,
  \ }}

  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction

  call s:profile(s:denite_options)

  " === Coc.nvim === "
  " use <tab> for trigger completion and navigate to next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()


  "Close preview window when completion is done.
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  " === NeoSnippet === "
  " Map <C-k> as shortcut to activate snippet if available
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)

  " Load custom snippets from snippets folder
  let g:neosnippet#snippets_directory='~/.config/nvim/snippets'

  " Hide conceal markers
  let g:neosnippet#enable_conceal_markers = 0

  " === NERDTree === "
  " Show hidden files/directories
  let g:NERDTreeShowHidden = 1

  " Remove bookmarks and help text from NERDTree
  let g:NERDTreeMinimalUI = 1

  " Custom icons for expandable/expanded directories
  let g:NERDTreeDirArrowExpandable = '⬏'
  let g:NERDTreeDirArrowCollapsible = '⬎'

  " Hide certain files and directories from NERDTree
  let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']

  " === echodoc === "
  " Enable echodoc on startup
  let g:echodoc#enable_at_startup = 1

  " === vim-javascript === "
  " Enable syntax highlighting for JSDoc
  let g:javascript_plugin_jsdoc = 1

  " === vim-jsx === "
  " Highlight jsx syntax even in non .jsx files
  let g:jsx_ext_required = 0

  " === javascript-libraries-syntax === "
  let g:used_javascript_libs = 'underscore,requirejs,chai,jquery'

  " === Signify === "
  let g:signify_sign_delete = '-'
  let g:webdevicons_enable_nerdtree = 1
  " ============================================================================ "
  " ===                                UI                                    === "
  " ============================================================================ "

  " Enable true color support
  set termguicolors

  colorscheme focuspoint

  let g:one_allow_italics = 1

  " Add custom highlights in method that is executed every time a
  " colorscheme is sourced
  " See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f for
  " details
  function! MyHighlights() abort
    " Hightlight trailing whitespace
    highlight Trail ctermbg=red guibg=red
    call matchadd('Trail', '\s\+$', 100)
  endfunction

  augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
  augroup END

  function DarkBackground()
    colorscheme focuspoint
    autocmd ColorScheme * call MyHighlights()
    " coc.nvim color changes
    hi! link CocErrorSign WarningMsg
    hi! link CocWarningSign Number
    hi! link CocInfoSign Type

    " Make background transparent for many things
    hi! Normal ctermbg=NONE guibg=NONE
    hi! NonText ctermbg=NONE guibg=NONE
    hi! LineNr ctermfg=NONE guibg=NONE
    hi! SignColumn ctermfg=NONE guibg=NONE
    hi! StatusLine guifg=#16252b guibg=#6699CC
    hi! StatusLineNC guifg=#16252b guibg=#16252b
  endfunction

  com DarkBackground call DarkBackground()
  com LightBackground colorscheme one | set background=light | let g:airline_theme='one'

  call DarkBackground()

  " Change vertical split character to be a space (essentially hide it)
  set fillchars+=vert:.

  " Set preview window to appear at bottom
  set splitbelow

  " Don't dispay mode in command line (airilne already shows it)
  set noshowmode

  set winbl=10

  " Try to hide vertical spit and end of buffer symbol
  hi! VertSplit gui=NONE guifg=#17252c guibg=#17252c
  hi! EndOfBuffer ctermbg=NONE ctermfg=NONE guibg=#17252c guifg=#17252c

  " Customize NERDTree directory
  hi! NERDTreeCWD guifg=#99c794

  " Make background color transparent for git changes
  hi! SignifySignAdd guibg=NONE
  hi! SignifySignDelete guibg=NONE

  hi! SignifySignChange guibg=NONE

  " Highlight git change signs
  hi! SignifySignAdd guifg=#99c794
  hi! SignifySignDelete guifg=#ec5f67
  hi! SignifySignChange guifg=#c594c5

  " Call method on window enter
  augroup WindowManagement
    autocmd!
    autocmd WinEnter * call Handle_Win_Enter()
  augroup END

  " Change highlight group of preview window when open
  function! Handle_Win_Enter()
    if &previewwindow
      setlocal winhighlight=Normal:MarkdownError
    endif
  endfunction

  " Wrap in try/catch to avoid errors on initial install before plugin is available
  try

  " === Vim airline ==== "
  " Enable extensions
  let g:airline_extensions = ['branch', 'hunks', 'coc']

  " Update section z to just have line number
  " let g:airline_section_z = airline#section#create(['linenr', 'maxlinenr'])

  " Do not draw separators for empty sections (only for the active window) >
  let g:airline_skip_empty_sections = 1

  " Smartly uniquify buffers names with similar filename, suppressing common parts of paths.
  let g:airline#extensions#tabline#formatter = 'unique_tail'

  " Custom setup that removes filetype/whitespace from default vim airline bar
  let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]

  let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'

  let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

  " Configure error/warning section to use coc.nvim
  let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
  let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

  " Hide the Nerdtree status line to avoid clutter
  let g:NERDTreeStatusline = ''

  " Disable vim-airline in preview mode
  let g:airline_exclude_preview = 1

  " Enable powerline fonts
  let g:airline_powerline_fonts = 1

  " Enable caching of syntax highlighting groups
  let g:airline_highlighting_cache = 1

  " Define custom airline symbols
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  " unicode symbols
  let g:airline_left_sep = '❮'
  let g:airline_right_sep = '❯'

  " Don't show git changes to current file in airline
  let g:airline#extensions#hunks#enabled=0

  catch
    echo 'Airline not installed. It should work after running :PlugInstall'
  endtry


  " ============================================================================ "
  " ===                             KEY MAPPINGS                             === "
  " ============================================================================ "

  " === Denite shorcuts === "
  "   ;         - Browser currently open buffers
  "   <leader>t - Browse list of files in current directory
  "   <leader>g - Search current directory for occurences of given term and
  "   close window if no results
  "   <leader>j - Search current directory for occurences of word under cursor
  nmap ; :Denite buffer -split=floating -winrow=1<CR>
  nmap <Leader>t :Denite file/rec -split=floating -winrow=1<CR>
  nnoremap <Leader>g :<C-u>Denite grep:. -split=floating -no-empty <CR>
  " nmap ; :Telescope buffers<CR>
  " nmap <Leader>t :Telescope find_files<CR>
  " nmap <Leader>k :Telescope live_grep<CR>
  nnoremap <Leader>j :<C-u>DeniteCursorWord -split=floating grep:. <CR>
  nmap <Leader>v :%s/<C-R>///gc<left><left><left>
  nmap <Leader>q :CtrlSF<CR>
  nmap <Leader>c oconsole.log(`===========\n${JSON.stringify(, null, 2)}\n===========`);<Esc>F(a
  nmap <Leader>z oconsole.dir(, { depth: null });<Esc>F(a
  vmap <Leader>f <Plug>CtrlSFVwordExec
  nmap <Leader>k <Plug>CtrlSFPrompt
  " === Nerdtree shorcuts === "
  "  <leader>n - Toggle NERDTree on/off
  "  <leader>f - Opens current file location in NERDTree
  nmap <Leader>n :NERDTreeToggle<CR>
  nmap <Leader>f :NERDTreeFind<CR>

  nmap <Leader>s :<C-u>split<CR>
  nmap <Leader>\| :<C-u>vsplit<CR>
  noremap <C-_> 0i// <Esc>
  noremap <C-S-/> 0i\/* <Esc> $i*/

  "   <Space> - PageDown
  "   -       - PageUp
  noremap <Space> <PageDown>
  noremap - <PageUp>

  " === coc.nvim === "
  function! s:GoToDefinition()
    if CocAction('jumpDefinition')
      return v:true
    endif

    let ret = execute("silent! normal \<C-]>")
    if ret =~ "Error"
      call searchdecl(expand('<cword>'))
    endif
  endfunction

  " nmap <silent> <leader>dd :call <SID>GoToDefinition()<CR>
  nmap <silent> <leader>dd :TsuDefinition <CR>
  nmap <silent> <leader>dr :TsuReferences <CR>
  nmap <silent> <leader>dj :TsuImplementations <CR>
  nmap <silent> <leader>DD <Plug>(coc-definition)
  nmap <silent> <leader>DR <Plug>(coc-references)
  nmap <silent> <leader>DJ <Plug>(coc-implementation)

  " === vim-better-whitespace === "
  "   <leader>y - Automatically remove trailing whitespace
  nmap <leader>y :StripWhitespace<CR>

  " === Search shorcuts === "
  "   <leader>h - Find and replace
  "   <leader>/ - Clear highlighted search terms while preserving history
  map <leader>h :%s///<left><left>
  nmap <silent> <leader>/ :nohlsearch<CR>

  " === Easy-motion shortcuts ==="
  "   <leader>w - Easy-motion highlights first word letters bi-directionally
  map <leader>w <Plug>(easymotion-bd-w)

  " Allows you to save files you opened without write permissions via sudo
  cmap w!! w !sudo tee %

  " === vim-jsdoc shortcuts ==="
  " Generate jsdoc for function under cursor
  " nmap <leader>z :JsDoc<CR>

  " Delete current visual selection and dump in black hole buffer before pasting
  " Used when you want to paste over something without it getting copied to
  " Vim's default buffer
  vnoremap <leader>p "_dP

  " ============================================================================ "
  " ===                                 MISC.                                === "
  " ============================================================================ "

  " Automaticaly close nvim if NERDTree is only thing left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " === Search === "
  " ignore case when searching
  set ignorecase

  " if the search string has an upper case letter in it, the search will be case sensitive
  set smartcase

  " Automatically re-read file if a change was detected outside of vim
  set autoread

  tnoremap <A-w> <C-\><C-n>
  augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
  augroup END

  " Reload icons after init source
  if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
  endif
else
  function! SetCursorLineNrColorInsert(mode)
      " Insert mode: blue
      if a:mode == "i"
          call VSCodeNotify('nvim-theme.insert')

      " Replace mode: red
      elseif a:mode == "r"
          call VSCodeNotify('nvim-theme.replace')
      endif
  endfunction


  function! SetCursorLineNrColorVisual()
      set updatetime=0
      call VSCodeNotify('nvim-theme.visual')
  endfunction

  vnoremap <silent> <expr> <SID>SetCursorLineNrColorVisual SetCursorLineNrColorVisual()
  nnoremap <silent> <script> v v<SID>SetCursorLineNrColorVisual
  nnoremap <silent> <script> V V<SID>SetCursorLineNrColorVisual
  nnoremap <silent> <script> <C-v> <C-v><SID>SetCursorLineNrColorVisual

  function! SetCursorLineNrColorVisual()
      set updatetime=0
      call VSCodeNotify('nvim-theme.visual')
  endfunction

  vnoremap <silent> <expr> <SID>SetCursorLineNrColorVisual SetCursorLineNrColorVisual()
  nnoremap <silent> <script> v v<SID>SetCursorLineNrColorVisual
  nnoremap <silent> <script> V V<SID>SetCursorLineNrColorVisual
  nnoremap <silent> <script> <C-v> <C-v><SID>SetCursorLineNrColorVisual


  augroup CursorLineNrColorSwap
      autocmd!
      autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
      autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
      autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
  augroup END

  " Remap leader key to ,
  let mapleader=','
  nmap <Leader>c oconsole.log(`===========\n${JSON.stringify(, null, 2)}\n===========`);<Esc>F(a
  nmap <Leader>z oconsole.dir(, { depth: null });<Esc>F(a
  nnoremap <Leader>k <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
  nnoremap <Leader>dd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  nnoremap <Leader>DD <Cmd>call VSCodeNotify('editor.action.peekImplementation')<CR>
  nnoremap <Leader>\| <Cmd> call VSCodeNotify('workbench.action.splitEditor')<CR>
  nnoremap <Leader>t <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
  nnoremap <Leader>dr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  noremap <Space> <PageDown>
  noremap - <PageUp>
  map <C-c> "+y

  " === TAB/Space settings === "
  " Insert spaces when TAB is pressed.
  set expandtab

endif

