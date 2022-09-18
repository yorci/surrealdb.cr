require "../model/**"

module SurrealDB
  extend self

  struct Emitter
    alias Responses = Model::Server::Return
    @store = Hash(String, Array(Channel(Responses))).new

    def on(id : String, ch : Channel(Responses))
      if @store.has_key? id
        @store[id] << ch
      else
        @store[id] = [ch]
      end
    end

    def emit(id : String, data : Responses)
      @store[id].each do |ch|
        ch.send data
      end
    end

    def removeAllListeners(id : String)
      @store.delete id
    end

    def once(id : String)
      ch = Channel(Emitter::Responses).new
      self.on(id, ch)
      yield
      data = ch.receive
      ch.close
      @store[id].delete ch
      data
    end
  end
end
