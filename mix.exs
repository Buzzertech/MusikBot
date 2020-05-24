defmodule Musikbot.MixProject do
  use Mix.Project

  def project do
    [
      app: :musikbot,
      version: "0.1.0",
      elixir: "~> 1.9.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger],
      mod: {Musikbot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 1.0.0"},
      {:httpoison, "~> 1.6"},
      {:mock, "~> 0.3.0", only: [:test, :ci]},
      {:poison, "~> 3.1"}
    ]
  end
end
