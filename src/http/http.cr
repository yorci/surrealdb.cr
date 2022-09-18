module SurrealDB
  class HTTP < Client
    EVENT_CHANNELS_M = %w(use let query create update change modify)
    EVENT_CHANNELS_S = %w(live kill select delete)
    EVENT_CHANNELS_N = %w(ping info invalidate)

    def initialize(@url : String)
    end

    def sign_in(user : String = "root", pass : String = "root")
    end

    def use(ns : String = "test", db : String = "test")
    end

    # Methods with multiple args
    {% for method in EVENT_CHANNELS_M %}
      def {{method.id}}(query : String, data)
        # self.send({{method.id.stringify}}, [query, data])
      end
    {% end %}

    # Methods with single arg
    {% for method in EVENT_CHANNELS_S %}
      def {{method.id}}(query : String)
        # self.send({{method.id.stringify}}, [query])
      end
    {% end %}

    # Methods with no-args
    {% for method in EVENT_CHANNELS_N %}
      def {{method.id}}
        # self.send({{method.id.stringify}}, [] of String)
      end
    {% end %}
  end
end
