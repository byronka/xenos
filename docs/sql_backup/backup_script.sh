#!/bin/bash
mysql -ubackup -pbackup -e 'STOP SLAVE SQL_THREAD;'
mysqldump -ubackup -pbackup --all-databases > fulldb.dump
mysql -ubackup -pbackup -e 'START SLAVE SQL_THREAD;'

