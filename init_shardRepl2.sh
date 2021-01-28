#!/bin/sh

singularity exec instance://mongod004 mongo --port 27007 < init_shardRepl2.js
