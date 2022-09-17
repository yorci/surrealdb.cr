require "./classes/*"
require "./exceptions/*"
require "./utils/*"

# TODO: Write documentation for `SurrealDB`
module SurrealDB
  VERSION = "0.1.0"

  # TODO: Put your code here
end

# test
pp! SurrealDB.guid
puts "+connect"
sdb = SurrealDB::WebSocket.new("http://0.0.0.0:8000/rpc")
spawn do
  sdb.listen
end

puts "+signin"
sdb.signin

puts "+use"
sdb.use

puts "+create"
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

puts "+select"
sdb.select("person")

puts "+change"
sdb.change(
  "person:jaime",
  {"marketing" => false}
)

puts "+select"
sdb.select("person")

puts "+query1"
sdb.query(
  "SELECT marketing, count() FROM type::table($tb) GROUP BY marketing",
  {"tb" => "person"}
)
puts "-query1"

puts "+query2"
sdb.query(
  "SELECT marketing, count() FROM type::table($tb) GROUP BY marketing",
  {"tb" => "person"}
)
puts "-query2"
