defmodule Prioqueue.Mixfile do
  use Mix.Project

  def project do
    [
      app: :prioqueue,
      version: "0.2.7",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      name: "Prioqueue",
      description: description(),
      source_url: "https://github.com/Qqwy/elixir-prioqueue",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:extractable, "~> 0.2"},
      {:insertable, "~> 0.2"},
      {:fun_land, "~> 0.10.0"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end


  defp description do
    """
    Well-structured Priority Queues for Elixir, offering a common interface with multiple implementations with varying performance guarantees that can be switched in your configuration.
    """
  end

  defp package() do
    [
      name: :prioqueue,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Qqwy/Wiebe-Marten Wijnja"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Qqwy/elixir-prioqueue"}
    ]
  end

end
