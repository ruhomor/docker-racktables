#!/bin/sh


# This file is part of docker-racktables.
#
# docker-racktables is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# docker-racktables is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <https://www.gnu.org/licenses/>.


APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"8080"}
SERVER_ADMIN=${SERVER_ADMIN:-"admin@example.com"}

if [ -w /etc/apache2/httpd.conf ]; then
	cat /etc/apache2/httpd.conf.template | envsubst '${APACHE_HTTP_PORT} ${RACKTABLES_PATH} ${SERVER_ADMIN}' > /etc/apache2/httpd.conf
fi

if [ ! -f /etc/apache2/httpd.conf ]; then
	php /make_racktables_secret.php || exit $?
fi



if [ -f /run/apache2/httpd.pid ];then
	rm /run/apache2/httpd.pid
fi

exec httpd -D FOREGROUND $@