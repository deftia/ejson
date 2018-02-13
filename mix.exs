defmodule Ejson.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.trim()

  def project() do
    [
      app: :ejson,
      version: @version,
      elixir: "~> 1.4",
      description: "Get json values quickly.",
      deps: deps(),
      package: package()
    ]
  end

  def application() do
    []
  end

  defp deps() do
    [
      {:poison, "~> 3.1"},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      {:files, ~w(lib mix.exs README.md VERSION LICENSE)},
      {:maintainers, ["Gautham Ramachandran", "Abdulsattar Mohammed"]}
    ]
  end
end
