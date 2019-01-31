defmodule Dyc.MixProject do
  use Mix.Project

  def project do
    [
      app: :dyc,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
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
      {:csv, "~> 2.0.0"},
      {:excoveralls, "~> 0.5", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
    ]
  end
end
