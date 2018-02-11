defmodule Ejson do
  alias Poison

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
    if Enum.count(token) == 0 do
      json
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

  defp single_token(json, token) do
    cond do
      token == "#" -> Enum.count(json)
      is_numeric(token) && is_list(json) == true -> Enum.at(json, String.to_integer(token))
      true -> Map.get(json, token)
    end
  end
end
