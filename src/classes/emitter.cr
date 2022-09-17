module SurrealDB
  extend self

  struct Emitter
    alias Func = Nil | String 

    @store = Hash(String, Array(Func)).new

    def on(id : String, f : Func)
      @store[id] << f
    end

    def once(id : String, f : Func)
      self.on id do |f| 
        @store[id].delete f
        f.call 
      end 
    end

    def emit(id : String, **args )
      @store[id].each do |f|
        f.call args
      end
    end

    def removeAllListeners(id : String)
      @store.delete id 
    end
  end
end
