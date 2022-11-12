defmodule DiscordBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :discord_bot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [summary: [threshold: 100]],
      elixirc_paths: elixirc_paths(Mix.env),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DiscordBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:mox, "~> 1.0", only: :test},
      {:bypass, "~> 2.1", only: :test},
      {:type_check, "~> 0.12.1"},
      {:stream_data, "~> 0.5.0", only: :test},
      {:websockex, "~> 0.4.3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp elixirc_paths(env_name) do
    case env_name do
      :test -> ["lib", "test/mocks"]
       _ -> ["lib"]
    end
  end
end
