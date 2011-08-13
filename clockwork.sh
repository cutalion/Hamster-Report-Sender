if [ -f ./config/clockwork.conf ]; then
  . ./config/clockwork.conf
else
  echo "Create a config/clockwork.conf file, please. See config/clockwork.conf.template for example"
  exit 1;
fi

login_page=`curl $clockwork_url/login 2>/dev/null`

auth_token=${login_page#*\"csrf-token\" content=\"}
auth_token=${auth_token%%\"*}

auth_param=${login_page#*\"csrf-param\" content=\"}
auth_param=${auth_param%%\"*}

cookies=`tempfile`
login_query="$clockwork_url/user_sessions -F $auth_param=$auth_token -F user_session[email]=$email -F user_session[password]=$password"
curl $login_query -c $cookies > /dev/null 2>&1


grep user_credentials $cookies > /dev/null
if [ $? == 0 ]; then
  echo "Logged in! Yahoo!"
else
  echo "Can not login into clockwork :("
fi
