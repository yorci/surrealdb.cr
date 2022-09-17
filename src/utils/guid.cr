module SurrealDB
    extend self 
    def guid : String
        Random.new.hex
    end
end