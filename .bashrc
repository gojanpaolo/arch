if grep -q "Ubuntu" /etc/os-release; then
  source "/mnt/c/Users/Jan/Dropbox/env/.bashrcdeb"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  return
fi

# TODO: I think this is included by default in arch. learn what this does and remove if not needed
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTCONTROL=ignoredups

# https://wiki.archlinux.org/title/Dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

alias grep='grep --color=auto'
alias l='less'
alias L='less'
alias la='ls --color=auto -alFh'
alias v='nvim'
alias V='nvim'
alias :q='exit'
alias :Q='exit'
alias clip='xclip -selection clipboard'

alias gs='git status'
alias ga='git add -p'
alias gd='git diff'
alias gc='git commit -m'
alias gcd='git checkout develop'
alias grd='git rebase develop'
alias gpl='git pull'
alias gps='git push'

alias k='kubectl'
alias _k='kubectl --kubeconfig="$kubeconfig" --context="$context"'

alias klocal='kubectl --context="minikube"'
alias kdev='kubectl --context="gke_first-gaming-dev_us-central1_first-cluster"'
alias kpdev='kubectl --context="gke_tsg-parimax-dev_us-central1_main"'
alias kpreprod='kubectl --context="gke_tsg-1st-k8s-preprod_us-central1_first-cluster"'
alias kprod='kubectl --context="gke_tsg-1st-k8s_us-central1_first-cluster"'
alias kloadtesting='kubectl --context="gke_tsg-1st-k8s-preprod_us-central1-a_load-testing"'

alias ti='time terraform init '
alias tps='terraform show -no-color ./logs/tfplan/jantest.tfplan | nvim - '
alias tpsjson='terraform show -json ./logs/tfplan/jantest.tfplan | jq | nvim - '
alias tv='terraform validate'
alias tl='tflint --recursive --config="$(pwd)/.tflint.hcl" --max-workers=1 --format=compact'

alias 1d='cd ~/onedrive'

alias chrome='google-chrome-stable'

cht () {
    local selected
    selected=$(rg --no-heading --line-number '' ~/cht | \
        fzf --delimiter : --nth 1,3.. \
            --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
            --preview-window=right:70%) || return

    local file line
    file=$(echo "$selected" | cut -d: -f1)
    line=$(echo "$selected" | cut -d: -f2)

    [ -n "$file" ] && ${EDITOR:-nvim} +"$line" "$file"
}

kx() {
  read -p "suffix: " suffix
  kubexporter
  current_ctx=$(k config current-context)
  name="$current_ctx-$(date +"%Y-%m-%d")-$suffix"
  mv exports $name
  tarc "$name"

  if [[ ! -d "$HOME/onedrive/${PWD#/home/jan/tsg/}" ]]; then
    read -p "onedrive folder does not exist. Create it? (y/n): " move_to_onedrive
  else
    echo "onedrive folder exists. Moving to onedrive."
    move_to_onedrive="y"
  fi

  if [[ $move_to_onedrive == "y" ]]; then
    mkdir -p "$HOME/onedrive/${PWD#/home/jan/tsg}"
    mv "$name.tar.gz" "$HOME/onedrive/${PWD#/home/jan/tsg}"
  else
    echo "Not moving to onedrive."
  fi
}

decode() {
  cat | jq '.data | map_values(@base64d)'
}

istiodiscoveryaddress() {
  istioctl proxy-config bootstrap deploy/$1 | jq .bootstrap.node.metadata.PROXY_CONFIG.discoveryAddress
}

kflinkfinalize() {
  TERMINATING_NAMESPACES=$(kubectl get namespace --no-headers -o custom-columns=":metadata.name" --field-selector status.phase=Terminating)
  for namespace in $TERMINATING_NAMESPACES;
  do
    echo "Found namespace '$namespace'..."
    kubectl get flinkdeployment -n "$namespace" --no-headers |   awk '{print $1 }' |   xargs kubectl patch -n "$namespace" flinkdeployment -p '{"metadata":{"finalizers":[]}}'   --type=merge
  done
}

tarc() {
  name=${1%/} # remove trailing slash if present
  tar czf "$name.tar.gz" "$name"
}

gitcleanbranchlocal() {
  # delete unnecessary local branches
  for branch in $(git branch | grep -v '\*' | tr -d ' '); do
    git branch -d $branch
  done
}

gituser() {
  git config user.email "jan.paologo@amtote.com"
  git config user.name "Jan Paolo Go"
}

dwip() {
  dotfiles add -u
  dotfiles commit -m "wip"
  dotfiles push
}

glocal() {
  k config use-context minikube
  unset project
}

gdev() {
  gcloud container clusters get-credentials first-cluster --project first-gaming-dev --region us-central1 --dns-endpoint
  project=first-gaming-dev
}

gpdev() {
  gcloud container clusters get-credentials "main" --project="tsg-parimax-dev" --region="us-central1"
}

gpreprod() {
  gcloud container clusters get-credentials first-cluster --project tsg-1st-k8s-preprod --region us-central1 --dns-endpoint
  project=tsg-1st-k8s-preprod
}

gprod() {
  gcloud container clusters get-credentials "first-cluster" --project="tsg-1st-k8s" --region="us-central1" --dns-endpoint
  project=tsg-1st-k8s
}

gprodadmin() {
  gcloud container clusters get-credentials "first-cluster" --project="tsg-1st-k8s" --region="us-central1" --dns-endpoint --impersonate-service-account=ci-terraform-tsg@tsg-terraform.iam.gserviceaccount.com #--kubeconfig="$HOME/.kube/admin-config"
  project=tsg-1st-k8s
}

gloadtesting() {
  gcloud container clusters get-credentials "load-testing" --project="tsg-1st-k8s-preprod" --region="us-central1-a" --dns-endpoint
  project=tsg-1st-k8s-preprod
}

_knone() {
  unset kubeconfig
  unset context
  unset project
  echo "$kubeconfig" "$context" "$project"
}

_klocal() {
  kubeconfig=$HOME/.kube/config
  context=minikube
  unset project
  echo "$kubeconfig" "$context" "$project"
}

_kdev() {
  kubeconfig=$HOME/.kube/config
  context=gke_first-gaming-dev_us-central1_first-cluster
  project=first-gaming-dev
  echo "$kubeconfig" "$context" "$project"
}

_kpreprod() {
  kubeconfig=$HOME/.kube/config
  context=gke_tsg-1st-k8s-preprod_us-central1_first-cluster
  project=tsg-1st-k8s-preprod
  echo "$kubeconfig" "$context" "$project"
}

_kprod() {
  kubeconfig=$HOME/.kube/config
  context=gke_tsg-1st-k8s_us-central1_first-cluster
  project=tsg-1st-k8s
  echo "$kubeconfig" "$context" "$project"
}

_kloadtesting() {
  kubeconfig=$HOME/.kube/config
  context=gke_tsg-1st-k8s-preprod_us-central1-a_load-testing
  project=tsg-1st-k8s-preprod
  echo "$kubeconfig" "$context" "$project"
}

tsg() {
  cd "$HOME/tsg"
  pwd
}

dtest() {
  cd "$HOME/tsg/terraform-tsg/devopstest"
  pwd
  git checkout janwip
}

troot() {
  cd "$HOME/tsg/terraform-tsg"
  pwd
}

t00() {
  cd ~/tsg/terraform-tsg/0-bootstrap/0-shared/
  pwd
}

t01() {
  cd ~/tsg/terraform-tsg/0-bootstrap/1-dev/
  pwd
}

t03() {
  cd ~/tsg/terraform-tsg/0-bootstrap/3-preprod/
  pwd
}

t04() {
  cd ~/tsg/terraform-tsg/0-bootstrap/4-prod/
  pwd
}

t10() {
  cd ~/tsg/terraform-tsg/1-base/0-shared/
  pwd
}

t11() {
  cd ~/tsg/terraform-tsg/1-base/1-dev/
  pwd
}

t13() {
  cd ~/tsg/terraform-tsg/1-base/3-preprod/
  pwd
}

t14() {
  cd ~/tsg/terraform-tsg/1-base/4-prod/
  pwd
}

ta()
{
  tfwait
  time terraform apply "$@" 2>&1 | tee logs/tf.log
}

tp()
{
  tpx "$@"
  tpsvalid
}

tpx()
{
  if [[ ! -f .terraform.lock.hcl ]]; then
    echo "not needed here";
    pwd;
    return;
  fi;
  mkdir logs/tfplan/ -p;
  rm -f logs/tf.log
  tfwait
  time terraform plan -out=./logs/tfplan/jantest.tfplan "$@" 2>&1 | tee logs/tf.log
}

tprf()
{
    tp -refresh=false "$@"
    #rm -f logs/lock_id.log;
    #save_lock_id;
    #lock_id=$(< logs/lock_id.log);
    #if [[ -z "$lock_id" ]]; then
}

tpsvalid() {
  if grep -q "Error: " logs/tf.log; then
      #echo "tf locked";
      echo "tf error"
      cat logs/tf.log;
  else
      terraform show -no-color ./logs/tfplan/jantest.tfplan | nvim -;
  fi
}

#save_lock_id()
#{
#  awk '/^.*ID:/ { print $4 }' logs/tf.log > logs/lock_id.log
#}

tfunlock() {
#  set -x;
#  #terraform force-unlock -force "${1:-$(xsel -ob)}";
#  save_lock_id
#  terraform force-unlock -force "$(< logs/lock_id.log)";
#  set +x
  subpath=$(pwd | awk -F'/' '{ split($NF, a, "-"); print a[2] "/" $(NF-1) }')
  tflock=$(gcloud storage cat "gs://tsg-terraform-state-$subpath/default.tflock" 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    echo $tflock | jq '{Who, Operation, Created, ID}'
    tflock_generation=$(gcloud storage objects describe gs://tsg-terraform-state-$subpath/default.tflock --format="value(generation)")

    read -p "unlock? (y/n): " unlock
    if [[ $unlock == "y" ]]; then
      terraform force-unlock -force "$tflock_generation"
    fi
  fi
}

tfwait() {
  ask_unlock=${1:-"y"}
  subpath=$(pwd | awk -F'/' '{ split($NF, a, "-"); print a[2] "/" $(NF-1) }')
  tflock=$(gcloud storage cat "gs://tsg-terraform-state-$subpath/default.tflock" 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    echo $tflock | jq '{Who, Operation, Created, ID}'
    tflock_generation=$(gcloud storage objects describe gs://tsg-terraform-state-$subpath/default.tflock --format="value(generation)")

    if [[ $ask_unlock == "y" ]]; then
      read -p "unlock? (y/n): " unlock
      if [[ $unlock == "y" ]]; then
        terraform force-unlock -force "$tflock_generation"
        return
      fi
    fi

    sleep 2
    tfwait "n"
  fi
}

tfstate() {
  mkdir logs/tfstate/ --parents
  file=logs/$(date +"%Y-%m-%d-%H-%M-%S").tfstate
  terraform state pull > "$file"
  nvim "$file"
}

eenv() {
  "$HOME/Dropbox/env/env.sh"
}

venv() {
  nvim "$HOME/Dropbox/env/env.sh"
}

varch() {
  nvim "$HOME/Dropbox/env/arch.md"
}

vrc() {
  nvim "$HOME/.bashrc"
}

vcht() {
  nvim "$HOME/cht"
}

gwip() {
  commit_message=$1
  git add -A
  git commit -m "${commit_message:-wip} [skip ci]"
}

source <(kubectl completion bash)
complete -F __start_kubectl k
complete -F __start_kubectl _k
complete -F __start_kubectl kdev
complete -F __start_kubectl kpreprod
complete -F __start_kubectl kprod
complete -F __start_kubectl klocal
complete -F __start_kubectl kpdev
complete -F __start_kubectl kloadtesting

printf "%s " "$(dirs -p)"
export PS1="\n$ "

export PATH="$HOME/.istioctl/bin:$PATH" # TODO: remove when we install istioctl using pacman
export PATH="$HOME/.tfenv/bin:$PATH"

# k edit ns default
# error: unable to launch the editor "vi"
export EDITOR=nvim

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then . '/opt/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then . '/opt/google-cloud-sdk/completion.bash.inc'; fi

source ~/.atuinrc

# mentioned after running `sudo pacman -S nvm`
source /usr/share/nvm/init-nvm.sh

