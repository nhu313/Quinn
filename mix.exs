defmodule Quinn.Mixfile do
  use Mix.Project

  def project do
    [app: :quinn,
     version: "0.0.3",
     elixir: "~> 1.0.0",
     deps: deps,
     description: description,
     package: package]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end

   defp description do
    """
    Quinn is Elixir xml parser.
    """
  end

  defp package do
    [
      files:        [ "lib", "mix.exs", "README.md"],
      contributors: [ "Nhu Nguyen <nhu313@gmail.com>"],
      licenses:     [ "Apache 2" ],
      links:        %{"GitHub" => "https://github.com/nhu313/Quinn"}
    ]
  end
end
