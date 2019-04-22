#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
	echo "Run with: bash $0"
    exit 1
fi

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

function main {
	bold=$(tput bold)
	normal=$(tput sgr0)
	VERSION="$(echo "$0" | sed 's/\(.\/\)\?\(ubuntu-php\|.sh\)//g')"
	TMP_DIR=/tmp/phpzts
	INSTALL_DIR=/etc/phpzts

	if [ -d $TMP_DIR ]; then
		bold_echo "Removing old PHP ZTS data in $TMP_DIR"
		/bin/rm -rf "$TMP_DIR/*"
	else
		bold_echo "Creating temporary directory in $TMP_DIR"
		mkdir "$TMP_DIR"
	fi
	cd "$TMP_DIR"

	bold_echo "Installing Dependencies"

	apt update && \
	apt install -y libzip-dev bison autoconf build-essential pkg-config git-core \
	libbz2-dev libxml2-dev libxslt1-dev libssl-dev libicu-dev \
	libmysqlclient-dev libcurl4-openssl-dev

	bold_echo "Downloading php source"
	wget https://github.com/php/php-src/archive/php-$VERSION.tar.gz
	tar --extract --gzip --file php-$VERSION.tar.gz

	bold_echo "Downloading Pthreads"
	cd "$TMP_DIR/php-src-php-$VERSION/ext"
	git clone https://github.com/krakjoe/pthreads

	bold_echo "Configuring PHP Build"
	cd "$TMP_DIR/php-src-php-$VERSION"
	./buildconf --force

	CONFIGURE_STRING="
		--prefix=$INSTALL_DIR \
		--with-config-file-path=$INSTALL_DIR/cli
		--with-config-file-scan-dir=$INSTALL_DIR/etc
		--enable-pthreads=shared \
		--with-curl \
		--with-zlib \
		--with-openssl \
		--enable-simplexml \
		--with-pdo-mysql=mysqlnd \
		--with-mysqli \
		--enable-shared \
		--enable-maintainer-zts \
		--enable-sockets \
		--enable-mbstring \
		--enable-opcache \
		--without-pear \
		--enable-debug"
	./configure $CONFIGURE_STRING

	bold_echo "Making & Installing php $VERSION"
	make && make install
	
	bold_echo "Creating php.ini"
	cd "$TMP_DIR/php-src-php-$VERSION"
	mkdir -p "$INSTALL_DIR/cli/"
	cp "php.ini-production $INSTALL_DIR/cli/php.ini"

	echo "extension=pthreads.so" | tee -a "$INSTALL_DIR/cli/php.ini"

	bold_echo "Creating link for phpzts command"
	rm /usr/bin/phpzts
	ln -s $INSTALL_DIR/bin/php /usr/bin/phpzts

	bold_echo "Cleaning tmp folder"
	#rm -rf $TMP_DIR

}
function bold_echo {
	echo "${bold}${1}${normal}"
}

main "$@"
