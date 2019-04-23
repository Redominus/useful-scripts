#PHP ZTS + XDEBUG INSTALLER
This script installs in ubuntu php zts with pthreads and xdebug.
## Usage 
###Basic
`sudo bash ./ubuntu-php.sh`
###Version selection
If env vars `PHP_VERSION` and `XDEBUG_VERSION` are defined the script will try to download both of them and install. **Be warned: The script do not check compatibility or existence of versions**
`sudo PHP_VERSION=7.3.3 XDEBUG_VERSION=2.7.1 bash ./ubuntu-php.sh`
