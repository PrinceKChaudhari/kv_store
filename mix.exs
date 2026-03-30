defmodule KVStore.MixProject do
  use Mix.Project

  def project do
    [
      app: :kv_store,
      version: "1.0.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "KVStore",
      description: "A distributed fault-tolerant key-value store in Elixir"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {KVStore.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      {:jason, "~> 1.4"}
    ]
  end
end
