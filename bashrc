# mmd bash config

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
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


# Try to keep environment pollution down
unset use_color safe_term match_lhs

# functions

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

clrProxy(){
   assignProxy ""
}

isuProxy(){
   #user=YourUserName
   #read -p "Password: " -s pass &&  echo -e " "
   #proxy_value="http://$user:$pass@ProxyServerAddress:Port"
   proxy_value="http://192.168.1.2:3128"
   assignProxy $proxy_value  
}


# env variables

export PATH=${PATH}:~/scripts
export EDITOR='vim'
export BROWSER='chromium'

export SYSTEMC=/usr/local/systemc/


# aliases

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -ip'

alias b='cd ..'
alias ps='ps -el'
alias ll='ls -l'

alias emacs='emacs -nw'

alias pacfiles='find /etc -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null'

alias arch='alsi -a'

alias rdesktop_mmdbigbox='rdesktop -g 1280x720 -P -z -x l -k en-gb -r sound:off -u mmd 192.168.1.30:3389'

alias rtfn='elinks https://www.archlinux.org/feeds/news/'
