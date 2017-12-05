defmodule Quinn do

  def parse(xml, options \\ %{}) do
    Quinn.XmlParser.parse(xml, options)
  end

  def find(node, node_names) do
    Quinn.XmlNodeFinder.find(node, node_names)
  end
end
