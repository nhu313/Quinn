defmodule Quinn.XmlParserTest do
  use ExUnit.Case

  alias Quinn.XmlNode

  test "simple" do
    xml = "<head>Header Value</head>"
    expected = [%XmlNode{attr: [], name: :head, value: ["Header Value"]}]
    assert expected == Quinn.parse(xml)
  end

  test "value with escaped html" do
    xml = "<head>&lt;p&gt;A codebase.&lt;/p&gt;</head>"
    expected = [%XmlNode{attr: [], name: :head, value: ["<p>A codebase.</p>"]}]
    assert expected == Quinn.parse(xml)
  end

  test "simple with 1 attribute" do
    xml = "<head client_id = \"111\">Header Value</head>"
    expected = [%XmlNode{attr: [client_id: "111"], name: :head, value: ["Header Value"]}]
    assert expected == Quinn.parse(xml)
  end

  test "simple with more than one attribute" do
    xml = "<head client_id = \"111\" name=\"howard\" parent=\"html\">Header Value</head>"
    expected = [%XmlNode{attr: [client_id: "111", name: "howard", parent: "html"],
                  name: :head,
                  value: ["Header Value"]}]
    assert expected == Quinn.parse(xml)
  end

  test "simplified node" do
    xml = "<head name=\"Header Value\" />"
    expected = [%XmlNode{name: :head, attr: [name: "Header Value"], value: []}]
    assert expected == Quinn.parse(xml)
  end

  test "nested xml" do
    xml = "<head><title>Yahoo</title><title>Bing</title></head>"
    expected = [%XmlNode{attr: [],
                  name: :head,
                  value: [%XmlNode{attr: [], name: :title, value: ["Yahoo"]},
                          %XmlNode{attr: [], name: :title, value: ["Bing"]}]}]
    assert expected == Quinn.parse(xml)
  end

  test "more than one children" do
    xml = "<search><name>Yahoo</name><name>Google</name><name>Bing</name></search>"
    expected = [%XmlNode{attr: [],
                  name: :search,
                  value: [%XmlNode{attr: [], name: :name, value: ["Yahoo"]},
                          %XmlNode{attr: [], name: :name, value: ["Google"]},
                          %XmlNode{attr: [], name: :name, value: ["Bing"]}]}]
    assert expected == Quinn.parse(xml)
  end

  test "parse small rss feed" do
    [title] = File.read!("test/xml_parser/fixture/rss_small.xml")
              |> Quinn.parse
              |> Quinn.find([:item, :title])
    assert hd(title.value) =~ "My end of the deal"
  end

  test "parse simple rss feed" do
    [title | _] = File.read!("test/xml_parser/fixture/rss.xml")
                  |> Quinn.parse
                  |> Quinn.find([:title])
    assert hd(title.value) =~ "Stories"
  end

  test "parse sample atom" do
    [title | _] = File.read!("test/xml_parser/fixture/atom.xml")
                  |> Quinn.parse
                  |> Quinn.find([:entry, :title])
    assert hd(title.value) =~ "Wearing The Pants"
  end
end
