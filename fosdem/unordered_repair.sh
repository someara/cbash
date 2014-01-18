#!/bin/bash
source ../lib/functions.sh

update_file /dist/hal/the_pod_doors \
    /home/hal/files/the_pod_doors

directory /home/hal/files \
    hal  \
    2001 \
    0755

user hal \
    9000 \
    2001 \
    'I am afraid I can not do that dave' \
    /home/hal \
    /bin/bash

group space \
    2001


