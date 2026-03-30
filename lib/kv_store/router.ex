defmodule KVStore.Router do
  @moduledoc """
  REST HTTP API for the KV Store.

  GET    /             → welcome
  GET    /keys         → list all keys
  GET    /store        → all key-value pairs
  GET    /store/:key   → get value by key
  POST   /store/:key   → set key (body: {"value": "..."})
  DELETE /store/:key   → delete key
  DELETE /store        → flush everything
  GET    /stats        → store statistics
  POST   /peers        → add a peer node (body: {"node": "name@host"})
  GET    /peers        → list peers
  """
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  plug :match
  plug :dispatch

  # ── Routes ────────────────────────────────────────────────

  get "/" do
    json(conn, 200, %{
      name: "KVStore",
      version: "1.0.0",
      author: "PrinceKChaudhari",
      node: node(),
      endpoints: [
        "GET  /keys",
        "GET  /store",
        "GET  /store/:key",
        "POST /store/:key  body: {\"value\": \"...\"}",
        "DELETE /store/:key",
        "DELETE /store",
        "GET  /stats",
        "POST /peers  body: {\"node\": \"name@host\"}",
        "GET  /peers"
      ]
    })
  end

  get "/keys" do
    keys = KVStore.Store.keys()
    json(conn, 200, %{keys: keys, count: length(keys)})
  end

  get "/store" do
    data = KVStore.Store.all()
    json(conn, 200, %{store: data, count: map_size(data)})
  end

  get "/store/:key" do
    case KVStore.Store.get(key) do
      :not_found -> json(conn, 404, %{error: "key not found", key: key})
      value      -> json(conn, 200, %{key: key, value: value})
    end
  end

  post "/store/:key" do
    value = conn.body_params["value"]

    if is_nil(value) do
      json(conn, 400, %{error: "missing 'value' in request body"})
    else
      KVStore.Store.set(key, value)
      KVStore.Replicator.replicate(:set, key, value)
      json(conn, 200, %{ok: true, key: key, value: value})
    end
  end

  delete "/store/:key" do
    KVStore.Store.delete(key)
    KVStore.Replicator.replicate(:delete, key)
    json(conn, 200, %{ok: true, deleted: key})
  end

  delete "/store" do
    KVStore.Store.flush()
    json(conn, 200, %{ok: true, message: "store flushed"})
  end

  get "/stats" do
    stats = KVStore.Store.stats()
    json(conn, 200, stats)
  end

  post "/peers" do
    node_name = conn.body_params["node"]

    if is_nil(node_name) do
      json(conn, 400, %{error: "missing 'node' in request body"})
    else
      peer = String.to_atom(node_name)
      KVStore.Replicator.add_peer(peer)
      json(conn, 200, %{ok: true, peer_added: node_name})
    end
  end

  get "/peers" do
    peers = KVStore.Replicator.peers() |> Enum.map(&Atom.to_string/1)
    json(conn, 200, %{peers: peers, count: length(peers)})
  end

  match _ do
    json(conn, 404, %{error: "route not found"})
  end

  # ── Helpers ───────────────────────────────────────────────

  defp json(conn, status, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
