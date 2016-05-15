#!/bin/bash -xe

if [[ "$@" == "" ]]; then
	
	make distclean >/dev/null 2>&1 || true
	dh_clean >/dev/null 2>&1 || true
	
	rm -f COPYING ChangeLog README
	ln -s debian/copyright COPYING
	ln -s debian/changelog ChangeLog
	ln -s README.md README
	
	echo 9 > debian/compat
	touch NEWS
	
	PROJECT_NAME=$(cat debian/changelog | head -n 1 | awk '{print $1}')
	PROJECT_VER=$(cat debian/changelog | head -n 1 | awk '{print $2}' | awk -F '[()]' '{print $2}' | awk -F\- '{print $1}')
	PROJECT_MANTAINER=$(cat debian/changelog | awk '{if ($1=="--") print $2, $3}' | head -n 1)
	PROJECT_NICKNAME=$(echo ${PROJECT_MANTAINER} | awk '{print tolower($1)}')
	
	cp configure.ac.in configure.ac
	cp debian/copyright.in debian/copyright
	cp debian/control.in debian/control
	
	sed -i "s/%PROJECT_INIT%/AC_INIT\(\[${PROJECT_NAME}\]\,\ \[${PROJECT_VER}\]\)/g" configure.ac
	sed -i "s/%PROJECT_MANTAINER%/${PROJECT_MANTAINER}/g" debian/copyright
	sed -i "s/%PROJECT_MANTAINER%/${PROJECT_MANTAINER}/g" debian/control
	sed -i "s/%PROJECT_NAME%/${PROJECT_NAME}/g" debian/control
	sed -i "s/%PROJECT_NICKNAME%/${PROJECT_NICKNAME}/g" debian/control
	
	echo ${PROJECT_MANTAINER} > AUTHORS
	
	aclocal
	automake -a
	autoreconf
	
elif [[ "$@" == "-c" ]]; then
	
	make distclean >/dev/null 2>&1 || true
	dh_clean >/dev/null 2>&1 || true
	
	for I in $(find . -type d); do
		rm -f $I/Makefile.in
	done
	
	[[ "$(du NEWS 2>/dev/null | awk '{print $1}')" != "0" ]] || rm -f NEWS
	
	rm -rf autom4te.cache \
		aclocal.m4 \
		autoscan.log \
		configure.ac \
		configure \
		compile \
		AUTHORS \
		COPYING \
		ChangeLog \
		README \
		install-sh \
		depcomp \
		INSTALL \
		missing \
		debian/compat \
		debian/copyright \
		debian/control
	
fi
