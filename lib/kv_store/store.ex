defmodule KVStore.Store do
  @moduledoc """
  The heart of the KV Store.
  A GenServer holding all key-value pairs in memory.
  Fault-tolerant: crashes are supervised and restarted automatically.
  """
  use GenServer
  require Logger

  # ── Client API ────────────────────────────────────────────

  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @doc "Set a key → value"
  def set(key, value), do: GenServer.call(__MODULE__, {:set, key, value})

  @doc "Get value by key"
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  @doc "Delete a key"
  def delete(key), do: GenServer.call(__MODULE__, {:delete, key})

  @doc "List all keys"
  def keys(), do: GenServer.call(__MODULE__, :keys)

  @doc "Get all key-value pairs"
  def all(), do: GenServer.call(__MODULE__, :all)

  @doc "Flush everything"
  def flush(), do: GenServer.call(__MODULE__, :flush)

  @doc "Store stats"
  def stats(), do: GenServer.call(__MODULE__, :stats)

  # ── Server Callbacks ──────────────────────────────────────

  @impl true
  def init(state) do
    Logger.info("🗄️  KVStore.Store initialized")
    {:ok, %{data: state, ops: 0, started_at: DateTime.utc_now()}}
  end

  @impl true
  def handle_call({:set, key, value}, _from, state) do
    new_data = Map.put(state.data, key, value)
    Logger.debug("SET #{key} = #{inspect(value)}")
    {:reply, :ok, %{state | data: new_data, ops: state.ops + 1}}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    result = Map.get(state.data, key, :not_found)
    {:reply, result, %{state | ops: state.ops + 1}}
  end

  @impl true
  def handle_call({:delete, key}, _from, state) do
    new_data = Map.delete(state.data, key)
    Logger.debug("DELETE #{key}")
    {:reply, :ok, %{state | data: new_data, ops: state.ops + 1}}
  end

  @impl true
  def handle_call(:keys, _from, state) do
    {:reply, Map.keys(state.data), state}
  end

  @impl true
  def handle_call(:all, _from, state) do
    {:reply, state.data, state}
  end

  @impl true
  def handle_call(:flush, _from, state) do
    Logger.warn("⚠️  Store flushed!")
    {:reply, :ok, %{state | data: %{}, ops: state.ops + 1}}
  end

  @impl true
  def handle_call(:stats, _from, state) do
    stats = %{
      keys: map_size(state.data),
      total_ops: state.ops,
      uptime_seconds: DateTime.diff(DateTime.utc_now(), state.started_at),
      node: node()
    }
    {:reply, stats, state}
  end
end
