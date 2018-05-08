#!/bin/sh

#Start Mysql Server
mysqld_safe&

#Start Apache Server
apache2ctl -DFOREGROUND -k start
