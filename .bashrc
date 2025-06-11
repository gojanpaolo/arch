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

# https://wiki.archlinux.org/title/Dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

alias grep='grep --color=auto'
alias l='less'
alias la='ls --color=auto -alFh'
alias v='nvim'
alias :q='exit'

alias k='kubectl'

alias kx='kubexporter'
alias klocal='kubectl --context="minikube"'
alias kdev='kubectl --context="gke_first-gaming-dev_us-central1_first-cluster"'
alias kpreprod='kubectl --context="gke_tsg-1st-k8s-preprod_us-central1_first-cluster"'
alias kprod='kubectl --context="gke_tsg-1st-k8s_us-central1_first-cluster"'

alias ti='time terraform init '
alias tps='terraform show -no-color ./logs/tfplan/jantest.tfplan | nvim - '
alias tpsjson='terraform show -json ./logs/tfplan/jantest.tfplan | jq | nvim - '
alias tv='terraform validate'
alias tl='tflint --recursive --config="$(pwd)/.tflint.hcl" --max-workers=1 --format=compact'

tarczf() {
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

glocal() {
  k config use-context minikube
}

gdev() {
  gcloud container clusters get-credentials first-cluster --project first-gaming-dev --region us-central1 --dns-endpoint
}

gpreprod() {
  gcloud container clusters get-credentials first-cluster --project tsg-1st-k8s-preprod --region us-central1 --dns-endpoint
}

gprod() {
  gcloud container clusters get-credentials "first-cluster" --project="tsg-1st-k8s" --region="us-central1" --dns-endpoint
}

gprodadmin() {
  gcloud container clusters get-credentials "first-cluster" --project="tsg-1st-k8s" --region="us-central1" --dns-endpoint --impersonate-service-account=ci-terraform-tsg@tsg-terraform.iam.gserviceaccount.com #--kubeconfig="$HOME/.kube/admin-config"
}

troot() {
  cd "$HOME/tsg/terraform-tsg"
  pwd
}

t00() {
  cd ~/tsg/terraform-tsg/0-bootstrap/0-shared/
}

t01() {
  cd ~/tsg/terraform-tsg/0-bootstrap/1-dev/
}

t03() {
  cd ~/tsg/terraform-tsg/0-bootstrap/3-preprod/
}

t04() {
  cd ~/tsg/terraform-tsg/0-bootstrap/4-prod/
}

t11() {
  cd ~/tsg/terraform-tsg/1-base/1-dev/
}

t13() {
  cd ~/tsg/terraform-tsg/1-base/3-preprod/
}

t14() {
  cd ~/tsg/terraform-tsg/1-base/4-prod/
}



ta()
{
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


save_lock_id()
{
  awk '/^.*ID:/ { print $4 }' logs/tf.log > logs/lock_id.log
}


tfunlock()
{
  set -x;
  #terraform force-unlock -force "${1:-$(xsel -ob)}";
  save_lock_id
  terraform force-unlock -force "$(< logs/lock_id.log)";
  set +x
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

source <(kubectl completion bash)
complete -F __start_kubectl k
complete -F __start_kubectl _k
complete -F __start_kubectl kdev
complete -F __start_kubectl kpreprod
complete -F __start_kubectl kprod

printf "%s " "$(dirs -p)"
export PS1="\n$ "

export PATH="$HOME/.istioctl/bin:$PATH" # TODO: remove when we install istioctl using pacman
export PATH="$HOME/.tfenv/bin:$PATH"
