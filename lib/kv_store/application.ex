defmodule KVStore.Application do
  use Application
  require Logger

  @port 4000

  def start(_type, _args) do
    Logger.info("⚡ KVStore starting on port #{@port}...")

    children = [
      KVStore.Store,
      KVStore.Replicator,
      {Plug.Cowboy, scheme: :http, plug: KVStore.Router, options: [port: @port]}
    ]

    opts = [strategy: :one_for_one, name: KVStore.Supervisor]
    result = Supervisor.start_link(children, opts)
    Logger.info("✅ KVStore is live → http://localhost:#{@port}")
    result
  end
end
