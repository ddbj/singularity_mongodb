#!/bin/sh

singularity exec instance://mongod001 mongo --port 27004 < init_shardRepl1.js
