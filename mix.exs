defmodule CompileTimeCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :compile_time_cache,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: Mix.compilers() ++ [:tracker_cache]
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
    [{:fastglobal, "~> 1.0", runtime: false}]
  end
end
