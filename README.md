Quinn
=====

A very simple/rough draft XML parser in Elixir. I'm currently using `xmerl_scan.string` to parse the xml. It works for what I need, which is to parse rss feeds.

# Parsing


```elixir
Quinn.parse("<head><title short_name = \"yah\">Yahoo</title><title:content>Bing</title></head>")
```
Calling parse on the xml will produce
```elixir
[%Quinn.XmlNode{attr: [],
                name: :head,
                value: [%Quinn.XmlNode{attr: [short_name: "yah"],
                                       name: :title,
                                       value: ["Yahoo"]},
                        %Quinn.XmlNode{attr: [],
                                       name: :"title:content",
                                       value: ["Bing"]}]}]
```
# Finding nodes

Suppose you want to find all the body nodes from this structure:
```elixir
structure = %XmlNode{attr: nil,
                     name: :html,
                     value: [%XmlNode{attr: nil, name: :head, value: ["title"]},
                             %XmlNode{attr: nil, name: :title, value: []},
                             %XmlNode{attr: nil, name: :body, value: ["body1", "body2"]},
                             %XmlNode{attr: nil, name: :footer, value: [%XmlNode{attr: nil, name: :line, value: ["this"]}]},
                             %XmlNode{attr: nil, name: :body, value: [%XmlNode{attr: nil, name: :line, value: ["that"]}]},
                             %XmlNode{attr: [], name: :"content:encoded", value: ["<p>comet!!</p>"]}]}
```
You can call
```elixir
Quinn.find(structure, :body)
```
This will be the result:
```elixir
[%Quinn.XmlNode{attr: nil, name: :body, value: ["body1", "body2"]},
 %Quinn.XmlNode{attr: nil, name: :body, value: [%Quinn.XmlNode{attr: nil, name: :line, value: ["that"]}]}]
```
Or given the structure above, you want to find the node `line` inside `body`, then you can invoke it like this:
```elixir
Quinn.find(structure, [:body, :line])
```
The result will be
```elixir
[%XmlNode{attr: nil, name: :line, value: ["that"]}]
```
Please refer if you want to see more example on how it is used.

Please let me know if you come across any problem. I'm still new to Elixir so feel free to contribute or clean up the code.

# License
Quinn source code is released under Apache 2 License. Check LICENSE file for more information.
