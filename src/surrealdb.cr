require "./options"
require "./client"

module SurrealDB
  VERSION = "0.1.0"
  Log     = ::Log.for("surrealdb")

  def self.guid : String
    Random.new.hex
  end

  def self.create(url : String, client : WS.class | HTTP.class)
    client.new(url)
  end
end
