defmodule Ejson do
  @moduledoc """
  EJSON is an efficient library to access nested JSON data
  """
  alias Poison

  @doc """
  Get value from JSON string / Map / List, for a given path, raises error for invalid path.

  iex> Ejson.get(~s([1, 2, 3]), "#") # Fetches count of list
  {:ok, 3}
  iex> Ejson.get(~s({"name": "Gautham"}), "name") # Fetches the value for key "name"
  {:ok, "Gautham"}
  iex> Ejson.get(~s([1, 2, 3]), "1") # Fetches the value on the first index.
  {:ok, 2}

  iex> Ejson.get(~s({"nested": {"more_nested": {"value": "hello"}}}), "nested.more_nested.value") # Nested paths
  {:ok,"hello"}

  iex> Ejson.get(~s([{"nested": [{"value": 10}]}]), "0.nested.0.value") # Works with json array too!
  {:ok, 10}
  """

  def get(json, path) when is_map(json) or is_list(json) do
    traverse(json, split_path(path))
  end

  def get(json, path) when is_binary(json) do
    traverse(Poison.decode!(json), split_path(path))
  end

  defp split_path(path) do
    String.split(path, ".")
  end

  defp traverse(json, token) do
    if Enum.empty?(token) do
      {:ok, json}
    else
      [head | tail] = token
      traverse(single_token(json, head), tail)
    end
  end

  defp is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  defp single_token(json, token) when is_list(json) and token == "#" do
    Enum.count(json)
  end
  defp single_token(json, token) when is_map(json) and token == "#" do
    json |> Map.keys() |> Enum.count()
  end
  defp single_token(json, token) do
    if is_numeric(token) && is_list(json) do
      Enum.at(json, String.to_integer(token))
    else
      Map.get(json, token)
    end
  end
end
