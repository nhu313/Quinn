defmodule Quinn.XmlNodeFinder do
  @moduledoc """
  Contains functions for finding nodes on parsed XML.

  These are for internal use. The methods on [Quinn](Quinn.html) should be used.
  """

  def find([], _), do: []
  def find(nil, _), do: []
  def find([value], _) when is_binary(value), do: []
  def find([value | _], _) when is_binary(value), do: []

  def find(%{} = node, node_names) do
   find([node], node_names)
  end

  def find([%{name: name} = head | tail], node_name) when name == node_name do
   [head] ++ find(tail, node_name)
  end

  def find(nodes, [node_name]) do
   find(nodes, node_name)
  end

  def find([%{name: name} = head | tail], [node_name | child_name] = names) when name == node_name do
   find(head.value, child_name) ++ find(tail, names)
  end

  def find([head | tail], node_names) do
    find(head.value, node_names) ++ find(tail, node_names)
  end
end
