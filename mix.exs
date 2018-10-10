defmodule OpenTracing.MixProject do
  use Mix.Project

  def project do
    [
      app: :opentracing,
      version: "0.1.0",
      elixir: "~> 1.6",
      description: "OpenTracing API for Elixir",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def package do
    [
      maintainers: ["SaleMove TechMovers"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/salemove/opentracing-elixir"
      }
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
      # Build documentation (run `mix docs`)
      {:ex_doc, "~> 0.18.0", only: [:dev, :test], runtime: false}

      # Code linter
      {:credo, "~> 0.9", only: [:dev], runtime: false},

      # Static type checking tool
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  defp aliases() do
    [
      coverage: ["test --cover"],
      lint: ["compile", "credo", "dialyzer --halt-exit-status"]
    ]
  end
end
