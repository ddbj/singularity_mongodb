#!/bin/sh

NUM="007"

if [ ! -e db${NUM} ]; then
    mkdir db${NUM}
fi

if [ ! -e mongod${NUM}.log ]; then
    touch mongod${NUM}.log
fi

singularity instance start \
-B mongod${NUM}.conf:/etc/mongod.conf \
-B db${NUM}:/data/db \
-B mongod${NUM}.log:/var/log/mongodb/mongod.log \
mongodb.sif \
mongod${NUM}

singularity exec instance://mongod${NUM} mongod --config /etc/mongod.conf &

