#! /bin/bash
# Author: Nils Gerstner
# Last revision: 21st September 2018
# Version: v1
# Description: Update system and update/build vim from source

# Colored message
function cmsg() {
	case "$1" in
		red)    COLOR="\033[1;31m"
			;;
		blue)   COLOR="\033[1;34m"
			;;
		grey)   COLOR="\033[1;30m"
			;;
		lgrey)  COLOR="\033[0;37m"
			;;
		green)	COLOR="\033[0;32m"
			;;	
		lgreen)	COLOR="\033[1;32m"
			;;
	esac
	printf "${COLOR}${2}\33[0m\n"
}

LASTUPDATE="$(($(date +%s) - $(stat -c %Y /var/cache/apt/pkgcache.bin)))"
echo "vim hold" | sudo dpkg --set-selections
cmsg red "U P D A T I N G   S Y S T E M"

TIME=3600
if [ "$1" == "-f" ]; then
	TIME=1
	cmsg blue "Forcing update"
fi

if [ $LASTUPDATE -gt $TIME ]; then #3600
	cmsg blue "Last update $(($LASTUPDATE / 60)) minutes ago."
	cmsg grey "sudo apt update"
	sudo apt update

	# echo ""
	# echo "apt list --upgradable"
	# apt list --upgradable

	if [ $(apt-get upgrade -s |grep -P '^\d+ upgraded'|cut -d" " -f1) -ne 0 ]; then
		cmsg grey "sudo apt dist-upgrade"
		sudo apt dist-upgrade
		cmsg blue "sudo apt autoremove"
		sudo grey autoremove
		cmsg grey "sudo apt autoclean"
		sudo apt autoclean
	else
		cmsg blue "All packages are uptodate!"
	fi

	# Updating VIM

	cd /opt/vim
	VERSION="$(apt-cache show vim |grep -A4 checkinstall |grep Version| grep -o -e "[0-9].*")"
	COMMIT="$(git log --pretty=format:"%h" |head -n1)"

	cmsg red "\nU P D A T I N G   V I M"
	cmsg grey "Current commit: $COMMIT"
	cmsg blue "Pull changes from VIM git repository"
	cmsg grey "git pull"
	git pull
	if [ $COMMIT != $(git log --pretty=format:"%h" |head -n1) ]; then
		cmsg blue "Updating VIM"
		cmsg grey "./configure\n	  --with-features=huge\n	  --enable-multibyte\n	  --enable-rubyinterp=yes\n	  --enable-pythoninterp=yes\n	  --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \n	  --enable-python3interp=yes \n	  --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \n	  --enable-perlinterp=yes \n	  --enable-luainterp=yes \n	  --enable-gui=gtk3 \n	  --enable-cscope \n	  --prefix=/usr/local"
		./configure \
			--with-features=huge \
			--enable-multibyte \
			--enable-rubyinterp=yes \
			--enable-pythoninterp=yes \
			--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
			--enable-python3interp=yes \
			--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
			--enable-perlinterp=yes \
			--enable-luainterp=yes \
			--enable-gui=gtk3 \
			--enable-cscope \
			--prefix=/usr/local
#			--CMAKE_CXX_FLAGS:STRING=-fPIC

		cmsg grey "make VIMRUNTIMEDIR=/usr/local/share/vim/vim81"
		make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 #-d CMAKE_CXX_FLAGS:STRING=-fPIC

		cmsg grey "sudo checkinstall"
		sudo checkinstall -y
		NEWCOMMIT="$(git log --pretty=format:"%h" |head -n1)"
		NEWVERSION="$(apt-cache show vim |grep -A4 checkinstall |grep Version| grep -o -e "[0-9].*")"
		cd /opt/vim/
		cmsg grey "git show --summary"
		git show --summary
		cmsg blue "VIM has been updated from\n$VERSION, $COMMIT to $NEWVERSION, $NEWCOMMIT"
	else
		NCOMMIT="$(git log --pretty=format:"%h" |head -n1)"
		cmsg blue "VIM is at the latest version ($VERSION, $NCOMMIT)."
	fi
else
		cmsg lgreen "Your system repositories where updated $(($LASTUPDATE / 60)) minutes ago."
		cmsg grey "If you want to update your repositories anyway, use:"
		cmsg lgrey "$ update.sh -f"
fi

