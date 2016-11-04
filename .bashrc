if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
#export GREP_OPTIONS='--color=auto'
export HISTSIZE=1000
export HISTFILESIZE=1000
export JAVA_1_6_HOME=/usr/java/jdk1.6.0_45
export JAVA_1_7_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export JAVA_HOME=$JAVA_1_7_HOME

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
		PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
		;;
	screen)
		PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
		;;
esac

# fortune is a simple program that displays a pseudorandom message
# from a database of quotations at logon and/or logout.
# Type: "pacman -S fortune-mod" to install it, then uncomment the
# following line:

# [[ "$PS1" ]] && /usr/bin/fortune

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS. Try to use the external file
# first to take advantage of user additions. Use internal bash
# globbing instead of external grep binary.

# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)

if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then

	# we have colors :-)

	# Enable colors for ls, etc. Prefer ~/.dir_colors
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi


	# Use this other PS1 string if you want \W for root and \w for all other users:
	# PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h\[\033[01;34m\] \W'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w'; fi) \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

	alias ls="ls --color=auto -h"
	alias dir="dir --color=auto"
	alias grep="grep --colour=auto"
fi

PS1='\n\D{%F %T}:\n\[\033]0;${PWV}\007\]\[\033[1;33m\]\u@\h:\[\033[0m\]\[\033[1;32m\]\w\n\[\033[1;31m\]${PWV}#\[\033[0m\] '
PS2="> "
PS3="> "
PS4="+ "

# Try to keep environment pollution down, EPA loves us.
unset safe_term match_lhs

# Try to enable the auto-completion (type: "pacman -S bash-completion" to install it).
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Try to enable the "Command not found" hook ("pacman -S pkgfile" to install it).
# See also: https://wiki.archlinux.org/index.php/Bash#The_.22command_not_found.22_hook
[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash

export PATH=$JAVA_HOME/bin:/usr/share/ant/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin/:.
#export CDPATH=/data/mickaelm/buildbot

#
# INTEL CHANGES
#
#export http_proxy=http://proxy.ir.intel.com:911
#export https_proxy=http://proxy.ir.intel.com:911
#export no_proxy='localhost,.intel.com, 127.0.0.1'
#export GIT_PROXY_COMMAND=/usr/local/bin/git-proxy
#cd /data/mickaelm/buildbot/yamls/android/

export EDITOR=vim
export NO_CODE_CHECK=1
export FLEETCTL_ENDPOINT=http://etcd-discovery.intel.com:2379

export DB_CREDS=metrics:metrics
export DB_URL_MCG=mysql://cactus-metrics.tl.intel.com/metrics-prod
export DB_URL_OTC=mysql://cactus-metrics.tl.intel.com/metrics-otc
export DB_URL_META=mysql://cactus-metrics.tl.intel.com/metrics-meta
export DB_URL_AWR=mysql://acs.tl.intel.com/ACS_DB

function nse { sudo nsenter -p -u -m -i -n -t $(docker inspect -f '{{ .State.Pid }}' $1) ; }

# External function
. ~/bin/myprog.sh

