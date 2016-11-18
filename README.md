Quinn
=====

A simple XML parser in Elixir aims to parse rss/atom feeds. I'm currently using `xmerl_scan.string` to parse the xml.

# Parsing


```elixir
Quinn.parse("<head><title short_name = \"yah\">Yahoo</title><title:content>Bing</title:content></head>")
```
Calling parse on the xml will produce
```elixir
[%{attr: [], name: :head,
   value: [%{attr: [short_name: "yah"], name: :title, value: ["Yahoo"]},
           %{attr: [], name: :"title:content", value: ["Bing"]}]}]
```
# Finding nodes

Suppose you want to find all the body nodes from this structure:
```elixir
structure = %{attr: [],
              name: :html,
              value: [%{attr: [], name: :head, value: ["title"]},
                      %{attr: [], name: :title, value: []},
                      %{attr: [], name: :body, value: ["body1", "body2"]},
                      %{attr: [], name: :footer, value: [%{attr: [], name: :line, value: ["this"]}]},
                      %{attr: [], name: :body, value: [%{attr: [], name: :line, value: ["that"]}]},
                      %{attr: [], name: :"content:encoded", value: ["<p>comet!!</p>"]}]}
```
You can call
```elixir
Quinn.find(structure, :body)
```
This will be the result:
```elixir
[%{attr: [], name: :body, value: ["body1", "body2"]},
 %{attr: [], name: :body, value: [%{attr: [], name: :line, value: ["that"]}]}]
```
Or given the structure above, you want to find the node `line` inside `body`, then you can invoke it like this:
```elixir
Quinn.find(structure, [:body, :line])
```
The result will be
```elixir
[%{attr: [], name: :line, value: ["that"]}]
```

# Naive Map

Converts xml string to an Elixir map which is convenient since no set-up is required (no xpath specification).  This tool is inspired by the convenience of Rails Hash.from_xml() but is "naive" in that it carries the same drawbacks.  Attributes on nodes don't carry over if the node has just one text value.  Sometimes you will get lists or a map key depending on the cardinality of sibling nodes detected at a level.  

For example 

```elixir
Quinn.naive_map("<transaction><order>1</order><order>2</order></transaction>")
#detects 2 siblings so you'll get:
%{transaction: %{order: ["1", "2"]}}
#But if no siblings, you'll not get a list:
Quinn.naive_map("<transaction><order>3</order></transaction>")
%{transaction: %{order: "3"}}
```


Please refer to the tests if you want to see more example on how it is used.

Please let me know if you come across any problem. I'm still new to Elixir so feel free to contribute or clean up the code.

# License
Quinn source code is released under Apache 2 License. Check LICENSE file for more information.
