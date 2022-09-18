require "json"
require "http/web_socket"
require "./emitter"
require "../model/server"

module SurrealDB
  class WebSocket 
    @events = Emitter.new

    # websocket ping interval
    PING_TIMEOUT = 30.seconds

    # Websocket Event Channels
    EVENT_CHANNELS_M = %w(use let query create update change modify)
    EVENT_CHANNELS_S = %w(live kill select delete)
    EVENT_CHANNELS_N = %w(ping info invalidate)

    def initialize(@url : String)
      @ws = ::HTTP::WebSocket.new(URI.parse(@url))

      @ws.on_message do |msg|
        Log.debug { "on_message -> #{msg}" }
        self.on_message msg
      end

      @ws.on_close do |msg|
        Log.debug { "on_close -> #{msg}" }
      end

      self.connect
    end

    def connect
      Log.debug { "+connect" }

      spawn do
        Log.debug { "+run" }
        @ws.run
      end

      spawn do
        loop do
          Log.debug { "+ping" }
          sleep PING_TIMEOUT
          self.ping
        end
      end
    end

    def authenticate(user : String = "root", pass : String = "root")
      self.sign_in(user, pass)
    end

    def sign_up(user : String = "root", pass : String = "root")
      self.sign_in(user, pass)
    end

    def sign_in(user : String = "root", pass : String = "root")
      self.send("signin", [{"user" => user, "pass" => pass}])
    end

    private def send(method : String, data : Array | NamedTuple | Hash)
      id = SurrealDB.guid
      msg = {"id" => id, "method" => method, "params" => data}.to_json
      Log.debug { "on_send => #{msg}" }

      @events.once(id) do
        @ws.send(msg)
      end
    end

    private def on_message(msg : String)
      data = WebsocketResponse.from_json msg
      @events.emit(data.id, data)
    end

    # Methods with multiple args
    {% for method in EVENT_CHANNELS_M %}
      def {{method.id}}(query : String, data)
        self.send({{method.id.stringify}}, [query, data])
      end
    {% end %}

      # Methods with single arg
      {% for method in EVENT_CHANNELS_S %}
      def {{method.id}}(query : String)
        self.send({{method.id.stringify}}, [query])
      end
    {% end %}

      # Methods with no-args
      {% for method in EVENT_CHANNELS_N %}
      def {{method.id}}
        self.send({{method.id.stringify}}, [] of String)
      end
    {% end %}
  end
end
