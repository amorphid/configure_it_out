defmodule Compiletime.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :compiletime,
      build_embedded:  Mix.env == :prod,
      deps:            deps(),
      description:     description(),
      elixir:          "~> 1.3",
      package:         package(),
      start_permanent: Mix.env == :prod,
      version:         "0.2.0",
    ]
  end

  def application do
    [
      applications: applications()
    ]
  end

  defp applications do
    [
      :logger
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "A collection of helpful compiletime tools"
  end

  defp package do
    %{
      maintainers: ["Michael Pope"],
      licenses:    ["Apache 2.0"],
      links:       %{github: "https://github.com/amorphid/compile"}
    }
  end
end
