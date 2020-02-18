#!/bin/bash 

if [ -f "/usr/local/etc/initialized" ]; then
  echo "Initialized."
else
  echo "Initializing..."
  echo "Creating config files..."
  echo "Creating pool_hba.conf..."
  echo "
  # TYPE  DATABASE    USER        CIDR-ADDRESS          METHOD

  # "local" is for Unix domain socket connections only
  local   all         all                               trust
  # IPv4 local connections:
  host    all         all         127.0.0.1/32          trust
  host    all         all         ::1/128               trust
  host    all         all         0.0.0.0/0             md5
  " > /usr/local/etc/pool_hba.conf

exec "$@"
