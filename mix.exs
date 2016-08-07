defmodule Quinn.Mixfile do
  use Mix.Project

  def project do
    [
      app: :quinn,
      version: "1.0.0",
      elixir: "~> 1.3",
      deps: deps,
      description: description,
      package: package
    ]
  end

  def application do
    [
      applications: [
        :xmerl
      ]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

   defp description do
    """
    Quinn is a simple XML parser mainly used to parse rss/atom feeds.
    """
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md"
      ],
      maintainers: [
        "Nhu Nguyen <nhu313@gmail.com>"
      ],
      licenses: [
        "Apache 2"
      ],
      links: %{
        "GitHub" => "https://github.com/nhu313/Quinn",
        "Docs" => "https://github.com/nhu313/Quinn"
      }
    ]
  end
end
