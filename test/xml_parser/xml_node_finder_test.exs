defmodule Quinn.NodeFinderTest do
  use ExUnit.Case

  alias Quinn.XmlNode

  @html_tree %XmlNode{attr: nil,
                      name: :html,
                      value: [%XmlNode{attr: nil, name: :head, value: ["title"]},
                              %XmlNode{attr: nil, name: :title, value: []},
                              %XmlNode{attr: nil, name: :body, value: ["body1", "body2"]},
                              %XmlNode{attr: nil, name: :footer, value: [%XmlNode{attr: nil, name: :line, value: ["this"]}]},
                              %XmlNode{attr: nil, name: :body, value: [%XmlNode{attr: nil, name: :line, value: ["that"]}]},
                              %XmlNode{attr: [], name: :"content:encoded", value: ["<p>comet!!</p>"]}]}

  test "when node is root" do
    assert Quinn.find(@html_tree, :html) == [@html_tree]
  end

  test "when node doesn't exist" do
    assert Quinn.find(@html_tree, :unknown) == []
  end

  test "when node name is a string" do
    node = %XmlNode{attr: [], name: :"content:encoded", value: ["<p>comet!!</p>"]}
    assert Quinn.find(@html_tree, :"content:encoded") == [node]
  end

  test "when node is the first child" do
    [body | _] = @html_tree.value
    assert Quinn.find(@html_tree, :head) == [body]
  end

  test "when node is not the first child" do
    second_child = %XmlNode{attr: nil, name: :title, value: []}
    assert Quinn.find(@html_tree, :title) == [second_child]
  end

  test "when node occurs more than once" do
    bodies = Enum.filter(@html_tree.value, fn(x) -> x.name == :body end)
    assert Quinn.find(@html_tree, :body) == bodies
  end

  test "find nested node more than once" do
    expected_node = [%XmlNode{attr: nil, name: :line, value: ["that"]}]
    assert Quinn.find(@html_tree, [:body, :line]) == expected_node
  end
end
