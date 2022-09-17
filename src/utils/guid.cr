module SurrealDB
    def self.guid : String
        Random.new.hex
    end
end