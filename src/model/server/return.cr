require "json"

struct SurrealDB::Model::Server::Return
  include JSON::Serializable

  @[JSON::Field(key: "id")]
  property id : String

  @[JSON::Field(key: "result")]
  property result : JSON::Any
end
