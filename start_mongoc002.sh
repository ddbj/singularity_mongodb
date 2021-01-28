#!/bin/sh

NUM="002"

if [ ! -e configdb${NUM} ]; then
    mkdir configdb${NUM}
fi

if [ ! -e mongoc${NUM}.log ]; then
    touch mongoc${NUM}.log
fi

singularity instance start \
-B mongoc${NUM}.conf:/etc/mongoc.conf \
-B configdb${NUM}:/data/configdb \
-B mongoc${NUM}.log:/var/log/mongodb/mongoc.log \
mongodb.sif \
mongoc${NUM}

singularity exec instance://mongoc${NUM} mongod --config /etc/mongoc.conf &
