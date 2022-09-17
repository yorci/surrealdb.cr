require "json"

module SurrealDB::Server
  extend self

  struct Return
    include JSON::Serializable
    
    @[JSON::Field(key: "id")]
    property id : String

    @[JSON::Field(key: "result")]
    property result : JSON::Any
  end
end
