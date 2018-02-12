defmodule EjsonTest do
  use ExUnit.Case, async: true
  doctest Ejson

  alias Ejson

  test "return count for a json array" do
    list_of_people = ~s([{
      "name": "David",
      "age": 20
    }, {
      "name": "Devin",
      "age": 22
    }])
    assert Ejson.get(list_of_people, "#") == {:ok, 2}
  end

  test "return number of keys for json object" do
    person_detail = ~s({
      "name": "David",
      "age": 20,
      "location": "India",
      "zipCode": 2000
    })
    assert Ejson.get(person_detail, "#") == {:ok, 4}
  end

  test "return nested json values" do
    person_detail = ~s({
      "name": "David",
      "location": {
        "zip": 10,
        "country": "Australia",
        "moreDetails": {
          "city": "Sydney"
        }
      }
    })

    assert Ejson.get(person_detail, "location.zip") == {:ok, 10}
    assert Ejson.get(person_detail, "location.moreDetails.city") == {:ok, "Sydney"}
  end

  test "access nested json arrays" do
    person_details = ~s([
      {
        "nested_array": [
          {
            "value": ["test"]
          }
        ]
      }
    ])
    assert Ejson.get(person_details, "0.nested_array.0.value") == {:ok, ["test"]}
    assert Ejson.get(person_details, "0.nested_array.0.value.0") == {:ok, "test"}
  end
end
