#!/bin/bash

/usr/local/mysql-5.5.42-osx10.8-x86_64/bin/mysql -u root <<END1

GRANT USAGE ON *.* TO 'bpmdemo'@'localhost' IDENTIFIED BY 'demo!123';
GRANT USAGE ON *.* TO 'notedb'@'localhost' IDENTIFIED BY 'demo!123';

DROP USER 'bpmdemo'@'localhost';
DROP USER 'notedb'@'localhost';

DROP DATABASE IF EXISTS bpmdemo;
DROP DATABASE IF EXISTS notedb;

CREATE DATABASE bpmdemo;
CREATE DATABASE notedb;

GRANT ALL PRIVILEGES ON bpmdemo.* TO 'bpmdemo'@'localhost' IDENTIFIED BY 'demo!123';
GRANT ALL PRIVILEGES ON notedb.* TO 'notedb'@'localhost' IDENTIFIED BY 'demo!123';

quit

END1

