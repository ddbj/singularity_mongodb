config = {
  "_id": "shardRepl_2",
  "members": [
    {"_id": 0, "host": "localhost:27007"},
    {"_id": 1, "host": "localhost:27008"},
    {"_id": 2, "host": "localhost:27009"}
  ]
}

rs.initiate(config)
