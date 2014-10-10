defmodule Elixgrep.Mixfile do
  use Mix.Project

  def project do
    [app: :elixgrep,
     version: "0.1.0",
     elixir: "> 0.15.0",
     name: "elixgrep",
     source_url: "https://github.com/bbense/elixgrep",
     homepage_url: "https://github.com/bbense/elixgrep/wiki",
     escript: escript,
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
     {:timex, "~> 0.12.7"},
     {:dir_walker, git: "git@github.com:bbense/dir_walker.git" },
     {:ex_doc, "~> 0.5", only: :dev}]
  end
end
