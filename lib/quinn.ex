defmodule Quinn do

  def parse(xml) do
    Quinn.XmlParser.parse(xml)
  end

  def find(node, node_names) do
    Quinn.XmlNodeFinder.find(node, node_names)
  end

  def naive_map(xml) do
    Quinn.XmlParser.parse(xml) |> Quinn.NaiveMap.parse
  end

end
