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
	libltdl-dev libbz2-dev libxml2-dev libxslt1-dev libssl-dev libicu-dev \
	libpspell-dev libenchant-dev libmcrypt-dev libpng-dev libjpeg8-dev \
	libfreetype6-dev libmysqlclient-dev libreadline-dev libcurl4-openssl-dev

	bold_echo "Downloading php source"
	wget https://github.com/php/php-src/archive/php-$VERSION.tar.gz
	tar --extract --gzip --file php-$VERSION.tar.gz

	bold_echo "Configuring PHP Build"
	cd "$TMP_DIR/php-src-php-$VERSION"
	./buildconf --force

	CONFIGURE_STRING="--prefix=$INSTALL_DIR --with-bz2 --with-zlib --enable-zip --disable-cgi \
	   --enable-soap --enable-intl --with-openssl --with-readline --with-curl \
	   --enable-ftp --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
	   --enable-sockets --enable-pcntl --with-pspell --with-enchant --with-gettext \
	   --with-gd --enable-exif --with-jpeg-dir --with-png-dir --with-freetype-dir --with-xsl \
	   --enable-bcmath --enable-mbstring --enable-calendar --enable-simplexml --enable-json \
	   --enable-hash --enable-session --enable-xml --enable-wddx --enable-opcache \
	   --with-pcre-regex --with-config-file-path=$INSTALL_DIR/cli \
	   --with-config-file-scan-dir=$INSTALL_DIR/etc --enable-cli --enable-maintainer-zts \
	   --with-tsrm-pthreads --enable-debug"
	./configure $CONFIGURE_STRING

	bold_echo "Making & Installing php $VERSION"
	make && make install
	
	bold_echo "Adding pthreads"
	sudo chmod o+x "$INSTALL_DIR/bin/phpize"
	sudo chmod o+x "$INSTALL_DIR/bin/php-config"

	git clone https://github.com/krakjoe/pthreads.git
	cd pthreads
	"$INSTALL_DIR/bin/phpize"
	bold_echo "Configuring pthreads"
	./configure \
	--prefix="$INSTALL_DIR" \
	--with-libdir='/lib/x86_64-linux-gnu' \
	--enable-pthreads=shared \
	--with-php-config="$INSTALL_DIR/bin/php-config"
	bold_echo "Making & Installing Pthreads"
	make && make install

	bold_echo "Creating php.ini"
	cd "$TMP_DIR/php-src-php-$VERSION"
	mkdir -p "$INSTALL_DIR/cli/"
	cp "php.ini-production $INSTALL_DIR/cli/php.ini"

	echo "extension=pthreads.so" | tee -a "$INSTALL_DIR/cli/php.ini"
	echo "zend_extension=opcache.so" | tee -a "$INSTALL_DIR/cli/php.ini"

	bold_echo "Creating link for phpzts command"
	rm /usr/bin/phpzts
	ln -s $INSTALL_DIR/bin/php /usr/bin/phpzts

	bold_echo "Cleaning tmp folder"
	rm -rf $TMP_DIR

}
function bold_echo {
	echo "${bold}${1}${normal}"
}

main "$@"
