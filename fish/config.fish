set -g -x PROJECT_PATH /home/lam/Documents/unito
set -g -x MONGOMS_SYSTEM_BINARY /usr/bin/mongod
set -g -x PATH $PATH /home/lam/.local/share/nvm/v14.18.1/bin/
set -gx PATH $PATH $HOME/.krew/bin

if [ -f ~/.secrets.fish ]; source ~/.secrets.fish; end
set -g -x NVM_DIR "$HOME/.nvm"

starship init fish | source

# Set keyboard layout with caps as escape
setxkbmap -variant intl -layout us -option caps:escape

alias v '/usr/bin/nvim'

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

function switch-nvim
  if test -e ~/.config/nvim/init.lua
    echo "Switching to vim-plug"
    mv ~/.config/nvim/init.lua ~/.config/nvim/wip-init.lua
    mv ~/.config/nvim/old-init.vim ~/.config/nvim/init.vim
  else if test -e ~/.config/nvim/init.vim
    echo "Switching to lazyvim"
    mv ~/.config/nvim/init.vim ~/.config/nvim/old-init.vim
    mv ~/.config/nvim/wip-init.lua ~/.config/nvim/init.lua
  end
end

function switch-git-user
  set gitconfig ''
  if test -e ~/.gitconfig.unito
    echo "Switching to unito git user"
    mv ~/.gitconfig ~/.gitconfig.personal
    mv ~/.gitconfig.unito ~/.gitconfig
  else if test -e ~/.gitconfig.personal
    echo "Switching to personal git user"
    mv ~/.gitconfig ~/.gitconfig.unito
    mv ~/.gitconfig.personal ~/.gitconfig
  else
    echo "No git user found"
  end
end

function gpr
  set projectName (git remote get-url origin | sed s/git@github.com:// | sed s/\\.git//)
  set branchName (git rev-parse --abbrev-ref HEAD)
  set defaultBranch (default_branch)
  google-chrome "https://github.com/$projectName/pull/new/$branchName"
end

function meteo
  set location ''
  if test (count $argv) -gt 0
    set location $argv[1]
  end

  curl wttr.in/$location
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

function current_branch
  git rev-parse --abbrev-ref HEAD
end

function shco
  if test (count $argv) -gt 0
    git show --color --pretty=format:%b $argv[1]
  else
    echo "Commit id required"
  end
end

function gp
  git push $argv
end

function default_branch
  git remote show origin | sed -n '/HEAD branch/s/.*: //p'
end

alias :q 'exit'

# UNITO ALIAS
alias unitorun '$PROJECT_PATH/internal-tools/dev/unitocli/unitorun.mjs'
alias unitorun-prod 'unitorun --account=prod'
alias unitorun-staging 'unitorun --account=staging'
alias connectorFn-prod 'unitorun-prod --role=admin $PROJECT_PATH/console/maestro/bin/script.js $PROJECT_PATH/console/maestro/scripts/connectorFn.js'
alias connectorFn-staging 'unitorun-staging node $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias connectorFn-local 'unitolocal node $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias debug-connectorFn-local 'unitolocal node --inspect-brk $PROJECT_PATH/console/maestro/bin/script.js scripts/connectorFn.js'
alias internal-tools 'cd $PROJECT_PATH/internal-tools'
alias link-local-libs '$PROJECT_PATH/internal-tools/dev/./local_libs.sh'
alias bump-connectors '$PROJECT_PATH/internal-tools/dev/./bump-connectors'
alias bump-ucommon '$PROJECT_PATH/internal-tools/dev/./bump-ucommon'
alias bump-connector-sdk '$PROJECT_PATH/internal-tools/dev/./bump-connector-sdk'
alias bump-external-connectors '$PROJECT_PATH/internal-tools/dev/./bump-external-connector'
alias daily-async-scrum "v /home/lam/Documents/unito/daily-async-scrum/daily-async-scrum(date '+%y%m')"
alias generate-aws-token '$PROJECT_PATH/internal-tools/dev/./generate-aws-creds.sh lamt'
alias prod-ips-api-key 'jq -r .apiKey ~/.config/integrationcli/configuration.json | xclip -selection clipboard'
alias staging-ips-api-key 'jq -r .apiKeyStaging ~/.config/integrationcli/configuration.json | xclip -selection clipboard'

# APP ALIAS

# CONFIG ALIAS
alias ufishrc 'v ~/.config/fish/config.fish'
alias upluginsvim 'v ~/.config/nvim/plugins.vim'
alias uinitvim 'v ~/.config/nvim/init.vim'
alias fishrc 'source ~/.config/fish/config.fish'
alias show-used-ports='sudo lsof -i -P -n | grep LISTEN'
alias cconfig 'cd ~/.config/'

# SYSTEM ALIAS
alias l "ls -l"
alias nilo "sudo"
alias android "/home/lam/Documents/bin/android-studio-2021.2.1.16-linux/android-studio/bin/studio.sh"

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
alias ggpurm "git pull --rebase origin (default_branch)"
alias gpsup "gp --set-upstream origin (current_branch)"
alias ggpush "gp origin (current_branch)"
alias ggp "gp origin (current_branch)"
alias gl "git pull"
alias gpf "gp -f"
alias grb "git rebase"
alias grba "git rebase --abort"
alias grbc "git rebase --continue"
alias grbs "git rebase --skip"
alias grbm "git rebase (default_branch)"
alias grbi "git rebase -i"
alias glrbm "gl --rebase origin (default_branch)"
alias glrb "gl --rebase"
alias grhh "git reset HEAD --hard"
alias grh "git reset HEAD"
alias gst "git status"
alias gsta "git stash save"
alias gstaa "git stash apply"
alias gstp "git stash pop"
alias gup "git pull --rebase"
alias gco "git checkout"
alias gcm "git checkout (default_branch)"
alias glo 'git log --pretty=format:"%C(bold Yellow)Subject: %s%n%C(bold Yellow)Commit: %H%n%C(red)Author: %an <%ae> %n%C(red)Author Date: %ad%n%Creset%b%n%N"'
alias gprune 'git fetch && git remote prune origin 2>&1 | grep "\[pruned\]" | sed -e "s@.*origin/@@g" | xargs git branch -D 2>&1 | grep -v "error: branch"'
alias gprw 'gh pr view --web'
alias git-filter-repo 'python3 ~/Documents/unito/bin/git-filter-repo'

# KUBECTL alias
alias k 'kubectl'
alias kn 'kubectl ns'
alias kc 'kubectl ctx'
alias ktoken 'kubectl -n kubernetes-dashboard create token admin-user | xclip -selection dashboard'

set file (cat ~/.aws/credentials)
set extracted (string match -r "\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d([+-][0-2]\d:[0-5]\d|Z)" "$file")[1]
set dateCredentials (date -d $extracted +%s)
set dateNow (date +%s)

if test $dateCredentials -lt $dateNow
  echo "Good morning"
  echo "Here's the weather for today"
  meteo
  generate-aws-token
  if test $status -eq 0
    read -l -P 'Do you want to run tmux? [y/N] ' response
    if string match -q -r '^([yY][eE][sS]|[yY])+$' "$response"
      exec tmux
    end
  else
    echo "Don't forget to regenerate your aws token"
  end
end
