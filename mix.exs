defmodule HdrHistogramr.MixProject do
  use Mix.Project

  def project do
    [
      app: :hdr_histogramr,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        bench: :bench
      ],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def aliases do
    [
      bench: "run benchmark.exs"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.28.0"},
      {:benchee, "~> 1.1", only: :bench},
      {:hdr_histogram, "~> 0.5.0", only: :bench}
    ]
  end
end
