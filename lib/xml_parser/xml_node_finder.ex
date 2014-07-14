defmodule Quinn.XmlNodeFinder do
  alias Quinn.XmlNode

  def find([], _), do: []
  def find(nil, _), do: []
  def find([value], _) when is_binary(value), do: []
  def find([value | _], _) when is_binary(value), do: []

  def find(%XmlNode{} = node, node_names) do
   find([node], node_names)
  end

  def find([%XmlNode{name: name} = head | tail], node_name) when name == node_name do
   [head] ++ find(tail, node_name)
  end

  def find(nodes, [node_name]) do
   find(nodes, node_name)
  end

  def find([%XmlNode{name: name} = head | tail], [node_name | child_name] = names) when name == node_name do
   find(head.value, child_name) ++ find(tail, names)
  end

  def find([head | tail], node_names) do
    find(head.value, node_names) ++ find(tail, node_names)
  end
end
