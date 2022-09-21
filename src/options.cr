require "json"

module SurrealDB
  alias Data = Nil | Bool | Int64 | Float64 | Char | String | Hash(Data, Data) | Array(Data)
  alias Responses = WSResponse | HTTPResponse

  struct WSResponse
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    property id : String

    @[JSON::Field(key: "result")]
    property result : JSON::Any
  end

  struct HTTPResponse
    include JSON::Serializable

    @[JSON::Field(key: "time")]
    property time : String

    @[JSON::Field(key: "status")]
    property status : String

    @[JSON::Field(key: "result")]
    property result : JSON::Any
  end

  struct HTTPErrorResponse
    include JSON::Serializable

    @[JSON::Field(key: "code")]
    property code : Int32

    @[JSON::Field(key: "details")]
    property details : String

    @[JSON::Field(key: "description")]
    property description : String

    @[JSON::Field(key: "information")]
    property information : String
    
  end
end
