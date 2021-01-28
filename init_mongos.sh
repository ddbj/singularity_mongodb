#!/bin/sh

singularity exec instance://mongos mongo --port 27013 < init_mongos.js
