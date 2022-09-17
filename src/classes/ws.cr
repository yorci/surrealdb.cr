require "http/web_socket"
require "json"
require "./*"
require "./../utils/*"

module SurrealDB
  # responses are not constant, it changes by event channel
  # signin  -> sent array of an object & returns empty string
  # use     -> sent array of ns and db & returns nil

  class WebSocket
    # might be used for authentication in the future (?)
    # HANDLERS = [] of HTTP::Handler

    # websocket ping interval
    PING_TIMEOUT = 30.seconds

    # Websocket Event Channels
    EVENT_CHANNELS_M = %w(query change create update modify)
    EVENT_CHANNELS_S = %w(select kill live delete)

    @token : String?
    @events = Hash(String, Array(Channel(Server::Return))).new

    def initialize(@url : String)
      @ws = HTTP::WebSocket.new(URI.parse(@url))

      @ws.on_message do |msg|
        self.on_message msg
      end

      @ws.on_binary do |msg|
        puts "on_binary -> #{msg}"
      end

      @ws.on_close do |msg|
        puts "on_close -> #{msg}"
      end
    end

    def listen
      puts "+run"
      @ws.run
    end

    def signin(user : String = "root", pass : String = "root")
      self.send("signin", [{"user" => user, "pass" => pass}])
    end

    def use(ns : String = "test", db : String = "test")
      self.send("use", [ns, db])
    end

    def info
      self.send("info", Array.new)
    end

    def invalidate
      self.send("invalidate", Array.new)
    end

    private def send(method : String, data : Array | NamedTuple | Hash)
      id = SurrealDB.guid
      msg = {"id" => id, "method" => method, "params" => data}.to_json
      puts "on_send => #{msg}"
      @ws.send(msg)

      ch = Channel(Server::Return).new
      self.listen id, ch
      ch.receive
    end

    private def on_message(msg : String)
      puts "on_message -> #{msg}"
      data = Server::Return.from_json msg
      @events[data.id].each do |ch|
        ch.send data
      end
    end

    private def listen(id : String, ch : Channel)
      if @events.has_key? id
        @events[id] << ch
      else
        @events[id] = [ch]
      end
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
  end
end
