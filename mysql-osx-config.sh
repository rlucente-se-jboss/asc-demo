#!/bin/bash

/usr/local/mysql-5.5.42-osx10.8-x86_64/bin/mysql -u root <<END1

GRANT USAGE ON *.* TO 'bpmdemo'@'localhost' IDENTIFIED BY 'demo!123';
DROP USER 'bpmdemo'@'localhost';
DROP DATABASE IF EXISTS bpmdemo;

CREATE DATABASE bpmdemo;
GRANT ALL PRIVILEGES ON bpmdemo.* TO 'bpmdemo'@'localhost' IDENTIFIED BY 'demo!123';

quit

END1

