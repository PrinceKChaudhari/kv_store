defmodule KVStore.Replicator do
  @moduledoc """
  Handles replication of SET/DELETE ops to connected nodes.
  This is what makes it *distributed* — when you write to one node,
  it propagates to all connected peers automatically.
  """
  use GenServer
  require Logger

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @doc "Add a peer node to replicate to"
  def add_peer(node), do: GenServer.cast(__MODULE__, {:add_peer, node})

  @doc "Remove a peer node"
  def remove_peer(node), do: GenServer.cast(__MODULE__, {:remove_peer, node})

  @doc "List all connected peers"
  def peers(), do: GenServer.call(__MODULE__, :peers)

  @doc "Replicate a write operation to all peers"
  def replicate(op, key, value \\ nil) do
    GenServer.cast(__MODULE__, {:replicate, op, key, value})
  end

  # ── Callbacks ─────────────────────────────────────────────

  @impl true
  def init(peers) do
    Logger.info("🔄 Replicator started with #{length(peers)} peers")
    {:ok, peers}
  end

  @impl true
  def handle_cast({:add_peer, node}, peers) do
    Logger.info("➕ Peer added: #{node}")
    {:noreply, [node | peers] |> Enum.uniq()}
  end

  @impl true
  def handle_cast({:remove_peer, node}, peers) do
    Logger.info("➖ Peer removed: #{node}")
    {:noreply, List.delete(peers, node)}
  end

  @impl true
  def handle_cast({:replicate, op, key, value}, peers) do
    Enum.each(peers, fn peer ->
      Task.start(fn ->
        try do
          case op do
            :set    -> :rpc.call(peer, KVStore.Store, :set, [key, value])
            :delete -> :rpc.call(peer, KVStore.Store, :delete, [key])
          end
          Logger.debug("✅ Replicated #{op} #{key} → #{peer}")
        rescue
          e -> Logger.warn("⚠️  Replication failed to #{peer}: #{inspect(e)}")
        end
      end)
    end)
    {:noreply, peers}
  end

  @impl true
  def handle_call(:peers, _from, peers), do: {:reply, peers, peers}
end
