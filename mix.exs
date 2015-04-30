defmodule Elixgrep.Mixfile do
  use Mix.Project

  def project do
    [app: :elixgrep,
     version: "0.3.0",
     elixir: "> 1.0.0",
     name: "elixgrep",
     source_url: "https://github.com/bbense/elixgrep",
     homepage_url: "https://github.com/bbense/elixgrep/wiki",
     escript: escript,
     description: description,
     package: package,
     deps: deps]
  end


  def escript do
    [main_module: Elixgrep]
  end
  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger ]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
 
  def deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:benchfella, git: "https://github.com/alco/benchfella.git", only: :dev},
     {:dir_walker, git: "https://github.com/bbense/dir_walker.git" },
     {:pluginator, git: "https://github.com/bbense/pluginator.git" },
     {:ex_doc, "~> 0.5", only: :dev}]
  end

  defp description do
    """
    A framework for doing Hadoop style map/reduce on lists of files/directories.
    The initial list of plugins implements concurrent versions of the unix find
    and grep utilities. 
    """
  end

  defp package do
    [# These are the default files included in the package
     files: ["lib", "plugin", "mix.exs", "README*", "readme*", "LICENSE*"],
     contributors: ["Booker Bense <bbense@gmail.com>"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/bbense/elixgrep",
              "Docs" => "http://bbense.github.io/elixgrep/"}]
  end
end
