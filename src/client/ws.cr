require "json"
require "http/web_socket"

module SurrealDB
  class WS < Client
    def initialize(url : String, @ping_timeout : Time::Span = 30.seconds)
      @ws = ::HTTP::WebSocket.new(URI.parse(url.sub("sql", "rpc")))
      @events = Emitter(WSResponse | WSErrorResponse).new

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
          sleep @ping_timeout
          self.ping
        end
      end
    end

    def authenticate(user : String = "root", pass : String = "root")
      self.signin(user, pass)
    end

    def signup(user : String = "root", pass : String = "root")
      self.send("singup", [{"user" => user, "pass" => pass}])
    end

    def signin(user : String = "root", pass : String = "root")
      self.send("signin", [{"user" => user, "pass" => pass}])
    end

    def use(ns : String, db : String)
      self.send("use", [ns, db])
    end

    def let(key : String, value : String)
      self.send("let", [key, value])
    end

    def query(query : String, params : Data)
      self.send("query", [query, params])
    end

    def create(table : String, params : Data)
      self.send("create", [table, params])
    end

    def update(table : String, params : Data)
      self.send("update", [table, params])
    end

    def change(table : String, params : Data)
      self.send("change", [table, params])
    end

    def modify(table : String, params : Data)
      self.send("modify", [table, params])
    end

    #
    def delete(data : String)
      self.send("delete", [data])
    end

    def kill(data : String)
      self.send("kill", [data])
    end

    def live(data : String)
      self.send("live", [data])
    end

    def select(data : String)
      self.send("select", [data])
    end

    #
    def invalidate
      self.fire_forget("invalidate")
    end

    def info
      self.fire_forget("info")
    end

    private def ping
      self.fire_forget("ping")
    end

    private def send(method : String, data : Array, wait : Bool = true)
      id = SurrealDB.guid
      msg = {"id" => id, "method" => method, "params" => data}.to_json
      Log.debug { "on_send => #{msg}" }

      if wait
        @events.once(id) do
          @ws.send(msg)
        end
      else
        @ws.send(msg)
      end
    end

    private def fire_forget(event : String)
      self.send(event, [] of String, false)
    end

    private def on_message(msg : String)
      begin
        data = WSResponse.from_json msg
      rescue ex
        data = WSErrorResponse.from_json msg
      end

      @events.emit(data.id, data)
    end
  end

  struct Emitter(T)
    @store = Hash(String, Array(Channel(T))).new

    def on(id : String, ch : Channel(T))
      if @store.has_key? id
        @store[id] << ch
      else
        @store[id] = [ch]
      end
    end

    def emit(id : String, data : T)
      @store[id].each do |ch|
        ch.send data
      end
    end

    def removeAllListeners(id : String)
      @store.delete id
    end

    def once(id : String)
      ch = Channel(T).new
      self.on(id, ch)
      yield
      data = ch.receive
      ch.close
      @store[id].delete ch
      data
    end
  end
end
