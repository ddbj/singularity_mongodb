#!/bin/sh

singularity exec instance://mongoc001 mongo --port 27000 < init_mongoc.js
