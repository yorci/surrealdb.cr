require "json"

module SurrealDB::Model
  struct WebsocketResponse
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    property id : String

    @[JSON::Field(key: "result")]
    property result : JSON::Any
  end

  struct HTTPResponse
    include JSON::Serializable

    @[JSON::Field(key: "result")]
    property result : JSON::Any
    @[JSON::Field(key: "time")]
    property time : String
    @[JSON::Field(key: "status")]
    property status : String
  end
end
