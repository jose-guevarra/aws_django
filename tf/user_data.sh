#!/bin/bash

# Install packages
sudo apt-get update
sudo apt-get -y -qq install fail2ban git python3-pip rdiff-backup libpq-dev uwsgi uwsgi-plugin-python3 nginx libmysqlclient-dev
