#!/bin/sh

singularity exec instance://mongod007 mongo --port 27010 < init_shardRepl3.js
