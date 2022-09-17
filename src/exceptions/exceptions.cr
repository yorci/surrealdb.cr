module SurrealDB::Exceptions
  class AuthenticationError < Exception
    def initialize
      super "AuthenticationError"
    end
  end

  class PermissionError < Exception
    def initialize
      super "PermissionError"
    end
  end

  class RecordError < Exception
    def initialize
      super "RecordError"
    end
  end
end
