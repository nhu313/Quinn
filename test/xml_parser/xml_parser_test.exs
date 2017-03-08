defmodule Quinn.XmlParserTest do
  use ExUnit.Case

  test "simple" do
    xml = "<head>Header Value</head>"
    expected = [%{attr: [], name: :head, value: ["Header Value"]}]
    assert expected == Quinn.parse(xml)
  end

  test "value with escaped html" do
    xml = "<head>&lt;p&gt;A codebase.&lt;/p&gt;</head>"
    expected = [%{attr: [], name: :head, value: ["<p>A codebase.</p>"]}]
    assert expected == Quinn.parse(xml)
  end

  test "simple with 1 attribute" do
    xml = "<head client_id = \"111\">Header Value</head>"
    expected = [%{attr: [client_id: "111"], name: :head, value: ["Header Value"]}]
    assert expected == Quinn.parse(xml)
  end

  test "simple with more than one attribute" do
    xml = "<head client_id = \"111\" name=\"howard\" parent=\"html\">Header Value</head>"
    expected = [%{attr: [client_id: "111", name: "howard", parent: "html"],
                  name: :head,
                  value: ["Header Value"]}]
    assert expected == Quinn.parse(xml)
  end

  test "simplified node" do
    xml = "<head name=\"Header Value\" />"
    expected = [%{name: :head, attr: [name: "Header Value"], value: []}]
    assert expected == Quinn.parse(xml)
  end

  test "nested xml" do
    xml = "<head><title>Yahoo</title><title>Bing</title></head>"
    expected = [%{attr: [],
                  name: :head,
                  value: [%{attr: [], name: :title, value: ["Yahoo"]},
                          %{attr: [], name: :title, value: ["Bing"]}]}]
    assert expected == Quinn.parse(xml)
  end

  test "more than one children" do
    xml = "<search><name>Yahoo</name><name>Google</name><name>Bing</name></search>"
    expected = [%{attr: [],
                  name: :search,
                  value: [%{attr: [], name: :name, value: ["Yahoo"]},
                          %{attr: [], name: :name, value: ["Google"]},
                          %{attr: [], name: :name, value: ["Bing"]}]}]
    assert expected == Quinn.parse(xml)
  end

  test "comments" do
    xml = "<head><title short_name = \"yah\">Yahoo</title><title:content>Bing</title:content><!-- foo --></head>"
    expected = [%{attr: [],
                  name: :head,
                  value: [%{attr: [short_name: "yah"], name: :title, value: ["Yahoo"]},
                          %{attr: [], name: :"title:content", value: ["Bing"]}]}]
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
