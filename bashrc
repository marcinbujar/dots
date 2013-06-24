# mmd bash config

[[ $- != *i* ]] && return

# check terminal size
shopt -s checkwinsize

# enable history appending instead of overwriting.
shopt -s histappend

# change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

use_color=false

# set colorful PS1
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we do not have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs



# FUNCTIONS

assignProxy(){
   PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY ALL_PROXY"
   for envar in $PROXY_ENV
   do
     if [[ ${1} == "" ]] ; then
        unset $envar
     else
        export $envar=$1
     fi
   done
   echo "Proxy set to $1"
}


#clrProxy(){
#   assignProxy ""
#}


#setProxy(){
#   #user=YourUserName
#   #read -p "Password: " -s pass &&  echo -e " "
#   #proxy_value="http://$user:$pass@ProxyServerAddress:Port"
#   assignProxy $proxy_value  
#}


alive() {
    DATE=2009/12/12
    DAYS=$((($(date +%s)-$(date -d "$DATE" +%s))/(24*60*60)))
    YEARS=$[$DAYS/365]
    echo -e "$DAYS days\n$YEARS years"
}



# ENVIRONMENT

export PATH=${PATH}:~/scripts
export EDITOR='vim'
export BROWSER='firefox'


# ALIASES

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -ip'
alias up='cd ..'
alias bb='cd -'
alias ps='ps -el'
alias ll='ls -l'
alias df='df -H'

alias py='python2'

alias pacfiles='find /etc -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null'
alias arch='alsi -a'
alias rtfn='elinks https://www.archlinux.org/feeds/news/'

alias ports='netstat -tulanp'

alias mouseOff='xinput set-int-prop "ETPS/2 Elantech Touchpad" "Device Enabled" 8 1'
alias mouseOn='xinput set-int-prop "ETPS/2 Elantech Touchpad" "Device Enabled" 8 0'

alias brightInc='xbacklight -inc 10'
alias brightDec='xbacklight -dec 10'

alias hax='echo -ne "\e[31m" ; while true ; do echo -ne "\e[$(($RANDOM % 2 + 1))m" ; tr -c "[:print:]" " " < /dev/urandom | dd count=1 bs=50 2> /dev/null ; sleep 0.1s ; done'
