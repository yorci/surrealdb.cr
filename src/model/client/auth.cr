require "json"

alias Auth = NamedTuple(user: String, pass: String, ns: String, db: String)

# struct SurrealDB::Model::Client::Auth
#   # include JSON::Serializable

#   # @[JSON::Field(key: "user")]
#   # property user : String

#   # @[JSON::Field(key: "pass")]
#   # property pass : String
# end
