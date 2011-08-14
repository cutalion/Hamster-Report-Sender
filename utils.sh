include() {
  until [ -z "$1" ]; do
    . $1
    shift
  done
}

visit() {
  local url=$1
  shift

  # echo "VISIT: curl $url "$@" -b $cookies -c $cookies"
  current_page=`curl $url "$@" -b $cookies -c $cookies 2>/dev/null`
}

auth_param_token() {
  local auth_token
  local auth_param

  auth_token=${1#*\"csrf-token\" content=\"}
  auth_token=${auth_token%%\"*}

  auth_param=${1#*\"csrf-param\" content=\"}
  auth_param=${auth_param%%\"*}

  echo "$auth_param=$auth_token"
}

login(){
  visit $CLOCKWORK_URL/login

  auth_pt=`auth_param_token "$current_page"`

  cookies=`tempfile`
  login_query="$CLOCKWORK_URL/user_sessions -F $auth_pt -F user_session[email]=$EMAIL -F user_session[password]=$PASSWORD"
  curl $login_query -c $cookies > /dev/null 2>&1

  grep user_credentials $cookies > /dev/null
  if [ $? == 0 ]; then
    return 0
  else
    return 1
  fi
}

post_timelog(){
  local date="$1"
  local hours="$2"
  local description="$3"
  local project="$4"
  local auth_pair=`auth_param_token "$current_page"`

  visit "$CLOCKWORK_URL/timelogs" -F $auth_pair -F timelog[date]="$date" -F timelog[hours_input]="$hours" -F timelog[description]="$description" -F timelog[project_title]="$project"
}
