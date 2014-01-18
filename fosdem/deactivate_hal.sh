#!/bin/bash

userdel hal 2>&1 > /dev/null
groupdel space 2>&1 > /dev/null
rm -rf /home/hal
rm -f /var/spool/mail/hal

