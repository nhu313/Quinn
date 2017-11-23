defmodule Quinn do

  def parse(xml, strip_namespaces \\ nil) do
    Quinn.XmlParser.parse(xml, strip_namespaces)
  end

  def find(node, node_names) do
    Quinn.XmlNodeFinder.find(node, node_names)
  end
end
