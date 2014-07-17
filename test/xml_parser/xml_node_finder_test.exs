defmodule Quinn.NodeFinderTest do
  use ExUnit.Case

  @html_tree %{attr: nil,
                      name: :html,
                      value: [%{attr: nil, name: :head, value: ["title"]},
                              %{attr: nil, name: :title, value: []},
                              %{attr: nil, name: :body, value: ["body1", "body2"]},
                              %{attr: nil, name: :footer, value: [%{attr: nil, name: :line, value: ["this"]}]},
                              %{attr: nil, name: :body, value: [%{attr: nil, name: :line, value: ["that"]}]},
                              %{attr: [], name: :"content:encoded", value: ["<p>comet!!</p>"]}]}

  test "when node is root" do
    assert Quinn.find(@html_tree, :html) == [@html_tree]
  end

  test "when node doesn't exist" do
    assert Quinn.find(@html_tree, :unknown) == []
  end

  test "when node name is a string" do
    node = %{attr: [], name: :"content:encoded", value: ["<p>comet!!</p>"]}
    assert Quinn.find(@html_tree, :"content:encoded") == [node]
  end

  test "when node is the first child" do
    [body | _] = @html_tree.value
    assert Quinn.find(@html_tree, :head) == [body]
  end

  test "when node is not the first child" do
    second_child = %{attr: nil, name: :title, value: []}
    assert Quinn.find(@html_tree, :title) == [second_child]
  end

  test "when node occurs more than once" do
    bodies = Enum.filter(@html_tree.value, fn(x) -> x.name == :body end)
    assert Quinn.find(@html_tree, :body) == bodies
  end

  test "find nested node more than once" do
    expected_node = [%{attr: nil, name: :line, value: ["that"]}]
    assert Quinn.find(@html_tree, [:body, :line]) == expected_node
  end
end
