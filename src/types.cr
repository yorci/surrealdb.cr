require "json"

module SurrealDB
  alias Data = Nil | Bool | Int64 | Float64 | Char | String | Hash(Data, Data) | Array(Data)

  struct WSResponse
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    property id : String

    @[JSON::Field(key: "result")]
    property result : Array(Response) | JSON::Any
  end

  struct WSErrorResponse
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    property id : String

    @[JSON::Field(key: "error")]
    property error : WSErrorSubResponse
  end

  struct WSErrorSubResponse
    include JSON::Serializable

    @[JSON::Field(key: "code")]
    property code : Int32

    @[JSON::Field(key: "message")]
    property message : String
  end

  struct Response
    include JSON::Serializable

    @[JSON::Field(key: "time")]
    property time : String

    @[JSON::Field(key: "status")]
    property status : String

    @[JSON::Field(key: "result")]
    property result : JSON::Any
  end

  struct ErrorResponse
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
