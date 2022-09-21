abstract class SurrealDB::Client
  abstract def authenticate(user : String, pass : String)
  abstract def signup(user : String, pass : String)
  abstract def signin(user : String, pass : String)
  abstract def use(ns : String, db : String)
  abstract def info
  abstract def invalidate

  abstract def let(key : String, value : String)
  abstract def query(query : String, params : Data)
  abstract def create(table : String, params : Data)
  abstract def update(table : String, params : Data)
  abstract def change(table : String, params : Data)
  abstract def modify(table : String, params : Data)
  abstract def select(data : String)
  abstract def delete(data : String)
  abstract def kill(data : String)
  abstract def live(data : String)
end

require "./client/*"
