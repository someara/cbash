#!/bin/bash

format="%-35s %-31s %5s\n"
# group space should exist
getent group space | cut -d: -f1 | grep -q ^space$
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "group" "'space'" "$state"

# group space should have gid 2001
getent group space | cut -d: -f3 | grep -q ^2001$
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "group space gid" "'2001'" "$state"

# user hal should exist
getent passwd hal | cut -d: -f1 | grep -q ^hal$
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "user" "'hal'" "$state"

# user hal should have uid 9000
getent passwd hal | cut -d: -f3 | grep -q ^9000$
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "user hal uid" "'9000'" "$state"

# user hal should have gid 2001
getent passwd hal | cut -d: -f4 | grep -q ^2001$
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "user hal gid" "'2001'" "$state"

# directory /home/hal/files should exist
test -d /home/hal/files
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "directory" "'/home/hal/files'" "$state"

# directory /home/hal/files should have owner 9000
test -d /home/hal/files && [ `stat -c '%u' /home/hal/files` == '9000' ]
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "directory /home/hal/files owner" "'9000'" "$state"

# directory /home/hal/files should have group 200
test -d /home/hal/files && [ `stat -c '%g' /home/hal/files` == '2001' ]
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "directory /home/hal/files group" "'2001'" "$state"

# directory /home/hal/files should have mode 755
test -d /home/hal/files && [ `stat -c '%a' /home/hal/files` == '755' ]
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "directory /home/hal/files mode" "'755'" "$state"

# file /home/hal/files/the_pod_doors should exist
test -d /home/hal/files && test -f /home/hal/files/the_pod_doors
if [ $? -eq 0 ]; then
    state='ONLINE'
else
    state='OFFLINE'
fi
printf "$format" "update_file /dist/hal/the_pod_doors" "'/home/hal/files/the_pod_doors'" "$state"
