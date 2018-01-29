defmodule Quinn do
  @moduledoc """
  The main entry point methods for using Quinn. Currently you can parse xml and find nodes in a parsed structure.
  """

  @doc """
  Parse a string of xml into elixir lists and maps.

  ## Example

      Quinn.parse("<head><title short_name = \"yah\">Yahoo</title><title:content>Bing</title:content></head>")

  will produce:

      [%{attr: [], name: :head,
         value: [%{attr: [short_name: "yah"], name: :title, value: ["Yahoo"]},
                 %{attr: [], name: :"title:content", value: ["Bing"]}]}]
  """
  def parse(xml, options \\ %{}) do
    Quinn.XmlParser.parse(xml, options)
  end

  @doc """
  Find a node from a list of parsed xml.

  ## Example

      Quinn.find(parsed_xml, :body)

  """
  def find(node, node_names) do
    Quinn.XmlNodeFinder.find(node, node_names)
  end
end
