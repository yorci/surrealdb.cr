require "./websocket/**"
require "./http/**"
require "./exceptions/*"
require "./utils/*"

# TODO: Write documentation for `SurrealDB`
module SurrealDB
  VERSION = "0.1.0"
  Log     = ::Log.for("db")

  enum Type
    Websocket
    HTTP
  end

  class Instance
    @ins : WebSocket | HTTP

    def initialize(
      @url : String,
      @connType : Type,
      @auth : Hash(String, String)
    )
      if @connType == Type::Websocket
        @ins = WebSocket.new(@url)
      else
        @ins = HTTP.new(@url)
      end

      Log.debug { "+signin" }
      @ins.sign_in @auth["user"], @auth["pass"]

      Log.debug { "+use" }
      @ins.use @auth["ns"], @auth["db"]
    end

    def i
      @ins
    end
  end
end
