defmodule Quinn.NaiveMap do

  # root case
  def parse([node]) do
    parse(node)
  end

  # peer siblings, collect a list
  def parse([%{name: name}, %{name: name} | _] = list)  do
    %{name => Enum.map(list, fn elem -> parse(elem.value) end)}
  end
  # different siblings, merge into map
  def parse(list) when is_list(list) and length(list) > 1  do
    Enum.reduce list, %{}, fn elem, acc ->
      parse(elem) |> Map.merge(acc) 
    end
  end

  # #one element as value, parse that value
  def parse(%{name: name, value: [value]}) do
    %{name => parse(value)}
  end
  #many children under this node, merge them all under one map
  def parse(%{attr: attr, name: name, value: list}) when is_list(list) and length(list) > 1 do
    %{name => Map.new(attr) |> Map.merge(parse(list))}
  end
  # #when value is node text
  def parse(value) do
    value
  end

end