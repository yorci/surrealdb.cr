
> [!WARNING]
> This library only works with SurrealDB 1.x and does not support SurrealDB 2.x. 
> Due to SurrealDB's future plans, we first need a CBOR RFC 8949 codec for Crystal to support SurrealDB v2.x.


# surrealdb

The unofficial SurrealDB library for Crystal.


## Todo

- [x] HTTP client tests
- [ ] Websocket client tests

*Contributions are welcome*


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     surrealdb:
       github: yorci/surrealdb.cr
   ```

2. Run `shards install`

## Usage

###  Connection 
```crystal
require "surrealdb"

# FOR HTTP Client
sdb = SurrealDB.create(
  url: "http://0.0.0.0:8000/sql",
  client: SurrealDB::HTTP,
)

# FOR Websocket Client
sdb = SurrealDB.create(
  url: "http://0.0.0.0:8000/rpc",
  client: SurrealDB::WS,
)

# Set authorization variables
sdb.signin "root", "root"
sdb.use "test", "test"

# Creates a records in a given table 
sdb.create(
  "person",
  {"title" => "Founder & CEO",
   "name"  => {
     "first" => "Tobie",
     "last"  => "Morgan Hitchcock",
   },
   "marketing"  => true,
   "identifier" => SurrealDB.guid,
  }
)

# Selects all records in given table  
sdb.select("person")

# Update a person record with a specific id
# note `#change` or `#update` both the same for http client
sdb.update(
  "person:jaime",
  {"marketing" => false}
)

# [WS] Perform a custom advanced query
sdb.query(
  "SELECT marketing, count() FROM type::table($tb) GROUP BY marketing",
  {"tb" => "person"}
)

# [HTTP] Perform a custom advanced query
# note: you cannot use query parameter for http client 
sdb.query(
  "SELECT marketing, count() FROM person GROUP BY marketing",
  nil
)

# [WS] Perform a custom advanced query
# this will return *WSErrorResponse* 
sdb.query(
  "SELECT marketing, counr() FROM type::table($tb) GROUP BY marketing",
  {"tb" => "person"}
)

# [HTTP] Perform a custom advanced query
# note: you cannot use query parameter for http client
# this will return *HTTPErrorResponse* 
sdb.query(
  "SELECT marketing, counr() FROM person GROUP BY marketing",
  nil
)
```

## Contributing

1. Fork it (<https://github.com/yorci/surrealdb/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Muhammed Yaşar](https://github.com/yorci) - creator and maintainer
