defmodule Quinn.XmlParser do

  def parse(xml, strip_namespaces) do
    :erlang.bitstring_to_list(xml)
    |> :xmerl_scan.string
    |> elem(0)
    |> parse_record(strip_namespaces)
  end

  defp combine_values([]), do: []

  defp combine_values(values) do
    if Enum.all?(values, &(is_binary(&1))) do
      [List.to_string(values)]
    else
      values
    end
  end

  defp parse_record({:xmlElement, name, _, _, _, _, _, attributes, elements, _, _, _}, strip_namespaces) do
    value = combine_values(parse_record(elements, strip_namespaces))
    if strip_namespaces == :strip_namespaces, do: name = name |> to_string |> String.split(":") |> List.last |> Macro.underscore |> String.to_atom
    [%{name: name, attr: parse_attribute(attributes), value: value}]
  end

  defp parse_record({:xmlText, _, _, _, value, _}, _) do
    string_value = String.strip(to_string(value))
    if (String.length(string_value) > 0) do
      [string_value]
    else
      []
    end
  end

  defp parse_record({:xmlComment, _, _, _, _value}) do
    []
  end

  defp parse_record([], _), do: []

  defp parse_record([element]), do: parse_record(element)

  defp parse_record([head | tail], strip_namespaces) do
    parse_record(head, strip_namespaces) ++ parse_record(tail, strip_namespaces)
  end

  defp parse_attribute([]), do: []

  defp parse_attribute({:xmlAttribute, name, _, _, _, _, _, _, value, _}) do
    [{name, to_string(value)}]
  end

  defp parse_attribute([attribute]) do
    parse_attribute(attribute)
  end

  defp parse_attribute([head | tail]) do
    parse_attribute(head) ++ parse_attribute(tail)
  end
end
