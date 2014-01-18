#!/bin/bash
source ../lib/functions.sh

group space \
    2001

user hal \
    9000 \
    2001 \
    'What are you doing, Dave?' \
    /home/hal \
    /bin/bash

directory /home/hal/files \
    hal  \
    2001 \
    0755

update_file /dist/hal/the_pod_doors \
    /home/hal/files/the_pod_doors



