defmodule Quinn.XmlParser do
  @moduledoc """
  Contains functions for parsing XML documents.

  These are for internal use. The methods on [Quinn](Quinn.html) should be used.
  """

  def parse(xml, options \\ %{}) do
    :erlang.bitstring_to_list(xml)
    |> :xmerl_scan.string
    |> elem(0)
    |> parse_record(options)
  end

  defp combine_values([]), do: []

  defp combine_values(values) do
    if Enum.all?(values, &(is_binary(&1))) do
      [List.to_string(values)]
    else
      values
    end
  end

  defp parse_record({:xmlElement, name, _, _, _, _, _, attributes, elements, _, _, _}, options) do
    value = combine_values(parse_record(elements, options))
    name = parse_name(name, options)
    [%{name: name, attr: parse_attribute(attributes), value: value}]
  end

  defp parse_record({:xmlText, _, _, _, value, _}, _) do
    string_value = String.trim(to_string(value))
    if (String.length(string_value) > 0) do
      [string_value]
    else
      []
    end
  end

  defp parse_record({:xmlComment, _, _, _, value}, options) do
    if options[:comments] do
      [%{name: :comments, attr: [], value: String.trim(to_string(value))}]
    else
      []
    end
  end

  defp parse_record([], _), do: []

  defp parse_record([head | tail], options) do
    parse_record(head, options) ++ parse_record(tail, options)
  end

  defp parse_attribute([]), do: []

  defp parse_attribute({:xmlAttribute, name, _, _, _, _, _, _, value, _}) do
    [{name, to_string(value)}]
  end

  defp parse_attribute([head | tail]) do
    parse_attribute(head) ++ parse_attribute(tail)
  end

  defp parse_name(name, %{strip_namespaces: true}) do
    name
    |> to_string
    |> String.split(":")
    |> List.last
    |> Macro.underscore
    |> String.to_atom
  end

  defp parse_name(name, _), do: name
end
