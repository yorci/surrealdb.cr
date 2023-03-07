require "./spec_helper"
require "../src/surrealdb"

guid = SurrealDB.guid
sdb = SurrealDB.create(
  url: ENV.fetch("SURREALDB_URL", "http://0.0.0.0:8000/sql"),
  client: SurrealDB::HTTP,
)

describe SurrealDB do
  it "connects" do
    sdb.should be_a(SurrealDB::HTTP)
  end

  it "auth" do
    sdb.signin "root", "root"
    sdb.use "test", "test"
  end

  it "create" do
    q = sdb.create(
      "person",
      {"title" => "Software Developer",
       "name"  => {
         "first" => "Muhammed",
         "last"  => "Yaşar",
       },
       "marketing"  => true,
       "identifier" => guid,
      }
    )
    q.should be_a Array(SurrealDB::Response)
  end

  it "select" do
    q = sdb.select("person")
    q.should be_a Array(SurrealDB::Response)
    q.as(Array(SurrealDB::Response)).first.result.as_a.empty?.should be_false
  end

  it "query" do
    q = sdb.query(
      %Q(SELECT identifier FROM person WHERE identifier = "#{guid}"),
      nil
    )
    q.should be_a Array(SurrealDB::Response)
    q.as(Array(SurrealDB::Response)).first.result[0]["identifier"].as_s.should eq guid
  end

  it "wrong query" do
    q = sdb.query(
      "SELECT marketing, counr() FROM person GROUP BY marketing",
      nil
    )
    q.should be_a SurrealDB::ErrorResponse
  end

  it "delete" do
    q = sdb.delete("person")
    q.should be_a Array(SurrealDB::Response)

    q2 = sdb.select("person")
    q2.should be_a Array(SurrealDB::Response)
    q2.as(Array(SurrealDB::Response)).first.result.as_a.empty?.should be_true
  end
end
