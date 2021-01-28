#!/bin/sh

if [ ! -e mongos_logs ]; then
    mkdir mongos_logs
fi

singularity instance start \
-B mongos.conf:/etc/mongos.conf \
-B mongos_logs:/var/log/mongodb \
mongodb.sif \
mongos

singularity exec instance://mongos mongos --config /etc/mongos.conf &
