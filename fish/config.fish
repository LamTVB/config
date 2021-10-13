set -g -x PROJECT_PATH /home/lam/Documents/unito
set -g -x MONGOMS_SYSTEM_BINARY /usr/bin/mongod
set -g -x PATH $PATH ~/Documents/bin/idea-IU-211.7628.21/bin/
set -g -x PATH $PATH ~/Documents/bin/WebStorm-211.7628.25/bin/
if [ -f ~/.secrets.fish ]; source ~/.secrets.fish; end
set -g -x NVM_DIR "$HOME/.nvm"

starship init fish | source

# Set keyboard layout with caps as escape
setxkbmap -variant intl -layout us -option caps:escape

alias v '/usr/bin/nvim'

for file in $PROJECT_PATH/bin/*
  if test -x $file
    set fileName (basename $file)
    alias $fileName "/.$file"
    alias "update-$fileName" "v $file"
  end
end

for file in /home/lam/Documents/bin/*
  if test -x $file
    set fileName (basename $file)
    alias $fileName "/.$file"
  end
end

for directory in $PROJECT_PATH/*
  if test -d $directory
    if test (basename $directory) = 'console'
      alias "maestro" "cd $directory/maestro"
      alias "client" "cd $directory/client"
    end
    alias (basename $directory) "cd $directory"
  end
end

function gpr
  set projectName (git remote get-url origin | sed s/git@github.com:// | sed s/\\.git//)
  set branchName (git rev-parse --abbrev-ref HEAD)
  google-chrome "https://github.com/$projectName/compare/master...$branchName?expand=1&w=1"
end

function link-lib
  if test (count $argv) -gt 0
    set libName $argv[1]
    if test -e "$PROJECT_PATH/$libName"
      rm -rf "node_modules/@unitoio/$libName"
      ln -s "$PROJECT_PATH/$libName" "node_modules/@unitoio/$libName"
    else
      echo "The project $libaName must be pulled before creating a link with it"
    end
  else
    echo "Need the library to link"
  end
end

function startup
  if test (count $argv) -gt 0
    if [ $argv[1] = "no_build" ];
      set syncWorkerStartup 'npm run start'
      set maestroStartup 'npm run dev:server'
    else if [ $argv[1] = "link" ];
      set syncWorkerStartup 'npm run realclean && npm ci & link-lib connectors && npm run start'
      set maestroStartup 'npm run clean && npm run setup && maestro && link-lib connectors && .. && npm run dev:server'
    end
  else
    set syncWorkerStartup 'npm run realclean && npm ci && npm run start'
    set maestroStartup 'npm run clean && npm run setup && npm run dev'
  end
  tmux new-session -d -s unito_env
  tmux split-window -v
  tmux split-window -h
  tmux select-pane -t 0
  tmux send-keys 'sync-worker' 'Enter'
  tmux send-keys "$syncWorkerStartup" 'Enter'
  tmux select-pane -t 1
  tmux send-keys 'console' 'Enter'
  tmux send-keys "$maestroStartup" 'Enter'
  tmux at
end

function clean-projects
  cd $PROJECT_PATH/sync-worker
  npm run realclean && npm i
  cd $PROJECT_PATH/console
  npm run clean && npm run setup
  cd $PROJECT_PATH/connectors
  npm run realclean && npm i
end

function robo3t
  if test (count $argv) -gt 0
    env QT_SCALE_FACTOR=$argv[1] ~/Documents/bin/robo3t/bin/./robo3t
  else
    ~/Documents/bin/robo3t/bin/./robo3t
  end
end

function current_branch -d "Output git's current branch name"
  begin
    git symbolic-ref HEAD; or \
    git rev-parse --short HEAD; or return
  end ^/dev/null | sed -e 's|^refs/heads/||'
end

function shco
  if test (count $argv) -gt 0
    git show --color --pretty=format:%b $argv[1]
  else
    echo "Commit id required"
  end
end

function gp
  if test (current_branch) = master
    cowsay -d 'No push on master'
  else
    git push $argv
  end
end

alias :q 'exit'

# UNITO ALIAS
alias connectorFn-prod 'unitoprod node $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias connectorFn-prod-debug 'unitoprod node --inspect-brk $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias connectorFn-staging 'unitostaging node $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias connectorFn-local 'unitolocal node $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias debug-connectorFn-local 'unitolocal node --inspect-brk $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias internal-tools 'cd $PROJECT_PATH/internal-tools'
alias link-local-libs '$PROJECT_PATH/internal-tools/dev/./local_libs.sh'
alias bump-connectors '$PROJECT_PATH/internal-tools/dev/./bump-connectors'
alias daily-async-scrum "v /home/lam/Documents/unito/daily-async-scrum/daily-async-scrum(date '+%y%m')"
alias generate-aws-token '$PROJECT_PATH/internal-tools/dev/./generate-aws-creds.sh lamt'

# APP ALIAS

# CONFIG ALIAS
alias ufishrc 'v ~/.config/fish/config.fish'
alias uplugins 'v ~/.config/nvim/plugins.vim'
alias uinitvim 'v ~/.config/nvim/init.vim'
alias fishrc 'source ~/.config/fish/config.fish'
alias show-used-ports='sudo lsof -i -P -n | grep LISTEN'
alias redis-server '~/./redis-stable/src/redis-server'
alias cconfig 'cd ~/.config/'

# SYSTEM ALIAS
alias l "ls -l"
alias nilo "sudo"

# GIT ALIAS
alias g git
alias ga "git add"
alias gau "git add -u"
alias gaa "git add -all"
alias gapa "git add --patch"
alias gb "git branch"
alias gba "git branch -a"
alias gc "git commit -v"
alias gc! "git commit -v --amend"
alias gcam "git commit -a -m"
alias gcsm "git commit -s -m"
alias gcb "git checkout -b"
alias gcmsg "git commit -m"
alias gd "git diff"
alias gdca "git diff --cached"
alias gg "git gui citool"
alias gk "gitk --all --branches"
alias ggpnp "git pull origin (current_branch) && gp origin (current_branch)"
alias ggpull "git pull origin (current_branch)"
alias ggl "git pull origin (current_branch)"
alias ggpur "git pull --rebase origin (current_branch)"
alias ggpurm "git pull --rebase origin master"
alias gpsup "gp --set-upstream origin (current_branch)"
alias ggpush "gp origin (current_branch)"
alias ggp "gp origin (current_branch)"
alias gl "git pull"
alias gpf "gp -f"
alias grb "git rebase"
alias grba "git rebase --abort"
alias grbc "git rebase --continue"
alias grbs "git rebase --skip"
alias grbm "git rebase master"
alias grhh "git reset HEAD --hard"
alias grh "git reset HEAD"
alias gst "git status"
alias gsta "git stash save"
alias gstaa "git stash apply"
alias gstp "git stash pop"
alias gup "git pull --rebase"
alias gco "git checkout"
alias gcm "git checkout master"
alias glo 'git log --pretty=format:"%C(bold Yellow)Subject: %s%n%C(bold Yellow)Commit: %H%n%C(red)Author: %an <%ae> %n%C(red)Author Date: %ad%n%Creset%b%n%N"'
alias gprune='git fetch && git remote prune origin 2>&1 | grep "\[pruned\]" | sed -e "s@.*origin/@@g" | xargs git branch -D 2>&1 | grep -v "error: branch"'

set file (cat ~/.aws/credentials)
set extracted (string match -r "\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d([+-][0-2]\d:[0-5]\d|Z)" "$file")[1]
set dateCredentials (date -d $extracted +%s)
set dateNow (date +%s)

if test $dateCredentials -lt $dateNow
  read -l -P 'Do you have your phone? [y/N] ' response
  if string match -q -r '^([yY][eE][sS]|[yY])+$' "$response"
    ssh-add ~/.ssh/unito_prod
    exec $PROJECT_PATH/internal-tools/dev/./generate-aws-creds.sh lamt
  else
    echo "You'll have to regenerate later"
  end
end
