<div align="center">
<img src="https://capsule-render.vercel.app/api?type=rect&color=0:4B0082,100:4B0082&height=3" width="100%"/>
</div>

<br/>

<div align="center">

<table border="0">
<tr>
<td align="left"><sub>● ● ●</sub></td>
<td align="center"><sub>~ / kv_store — iex — distributed@princekchaudhari</sub></td>
<td align="right"><sub>⌘</sub></td>
</tr>
</table>

```
██╗  ██╗██╗   ██╗    ███████╗████████╗ ██████╗ ██████╗ ███████╗
██║ ██╔╝██║   ██║    ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
█████╔╝ ██║   ██║    ███████╗   ██║   ██║   ██║██████╔╝█████╗
██╔═██╗ ╚██╗ ██╔╝    ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝
██║  ██╗ ╚████╔╝     ███████║   ██║   ╚██████╔╝██║  ██║███████╗
╚═╝  ╚═╝  ╚═══╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

<img src="https://readme-typing-svg.demolab.com?font=Ubuntu+Mono&size=14&duration=2000&pause=800&color=9B59B6&center=true&width=600&lines=Distributed.+Fault-tolerant.+Built+in+Elixir.;What+WhatsApp+used+to+handle+2M+connections.;SET.+GET.+REPLICATE.+SURVIVE."/>

<br/>

![Elixir](https://img.shields.io/badge/Elixir-1.14+-4B0082?style=flat-square&logo=elixir&logoColor=white&labelColor=0d1117)
![Erlang OTP](https://img.shields.io/badge/Erlang_OTP-25+-A90533?style=flat-square&labelColor=0d1117)
![License](https://img.shields.io/badge/License-MIT-9B59B6?style=flat-square&labelColor=0d1117)
![Status](https://img.shields.io/badge/Status-Active-00ff41?style=flat-square&labelColor=0d1117)
![Built By](https://img.shields.io/badge/Built_by-PrinceKChaudhari-4B0082?style=flat-square&labelColor=0d1117)

</div>

<br/>

---

<br/>

<table>
<tr>
<td width="50%" valign="top">

### What it does.

A **distributed key-value store** built in Elixir.

Think Redis — but you built it yourself.  
Think DynamoDB — but in 300 lines of code.

```
SET  "user:1" → "Prince"
GET  "user:1" → "Prince"
DEL  "user:1" → gone
```

Simple interface.  
Distributed underneath.  
Fault-tolerant by design.

</td>
<td width="50%" valign="top">

### Why Elixir.

Elixir runs on the **Erlang VM (BEAM)** —  
the same VM that powers:

```
WhatsApp     → 2M concurrent connections
Discord      → millions of users
WhatsApp     → 99.9999% uptime
```

Not chosen for hype.  
Chosen because it's **the right tool.**

</td>
</tr>
</table>

<br/>

---

<br/>

## `mix describe`

```
  COMPONENT         DESCRIPTION                           TECH
  ───────────────────────────────────────────────────────────────
  KVStore.Store     In-memory key-value GenServer         Elixir
  KVStore.Router    REST HTTP API (GET/POST/DELETE)       Plug + Cowboy
  KVStore.Replicator Replicates writes to peer nodes     Erlang RPC
  KVStore.Application Supervisor tree — crash & restart  OTP
  ───────────────────────────────────────────────────────────────
  Total             Distributed KV store with HTTP API
```

<br/>

---

<br/>

## `curl localhost:4000` — API Reference

<details>
<summary><b>Click to expand all endpoints</b></summary>

<br/>

```bash
# ── READ ─────────────────────────────────────────────────────

# Get a value
curl http://localhost:4000/store/mykey

# List all keys
curl http://localhost:4000/keys

# Get everything
curl http://localhost:4000/store

# Stats
curl http://localhost:4000/stats

# ── WRITE ────────────────────────────────────────────────────

# Set a value
curl -X POST http://localhost:4000/store/mykey \
  -H "Content-Type: application/json" \
  -d '{"value": "hello world"}'

# Delete a key
curl -X DELETE http://localhost:4000/store/mykey

# Flush everything
curl -X DELETE http://localhost:4000/store

# ── CLUSTER ──────────────────────────────────────────────────

# Add a peer node for replication
curl -X POST http://localhost:4000/peers \
  -H "Content-Type: application/json" \
  -d '{"node": "kv@192.168.1.2"}'

# List connected peers
curl http://localhost:4000/peers
```

</details>

<br/>

---

<br/>

## `mix run` — Getting Started

```bash
# ── Install Elixir ────────────────────────────────────────────
# Ubuntu/Debian
sudo apt install elixir

# Termux (yes, phone works 📱)
pkg install elixir

# ── Clone & Run ───────────────────────────────────────────────
git clone https://github.com/PrinceKChaudhari/kv_store.git
cd kv_store
mix deps.get
mix run --no-halt

# ── Server is live ────────────────────────────────────────────
# → http://localhost:4000
```

<br/>

> [!NOTE]
> Runs on Linux, macOS, Windows, and even **Termux on Android.**

<br/>

---

<br/>

## `iex -S mix` — Interactive Shell

```elixir
# Start interactive Elixir shell
iex -S mix

# Use the store directly
KVStore.Store.set("name", "Prince")       # → :ok
KVStore.Store.get("name")                 # → "Prince"
KVStore.Store.set("lang", "Elixir")       # → :ok
KVStore.Store.keys()                      # → ["name", "lang"]
KVStore.Store.stats()                     # → %{keys: 2, ops: 4, ...}
KVStore.Store.delete("name")              # → :ok
KVStore.Store.flush()                     # → :ok
```

<br/>

---

<br/>

## `Architecture`

```
  HTTP Request
       │
       ▼
  ┌─────────────────┐
  │  Plug.Cowboy    │  ← HTTP server
  │  KVStore.Router │  ← routes GET/POST/DELETE
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐        ┌──────────────────┐
  │  KVStore.Store  │        │KVStore.Replicator│
  │  (GenServer)    │───────▶│  (GenServer)     │
  │  in-memory map  │        │  peer nodes RPC  │
  └─────────────────┘        └────────┬─────────┘
                                      │
                              ┌───────┴──────┐
                              │              │
                         Node 2          Node 3
                         (peer)          (peer)
```

<br/>

---

<br/>

<div align="center">

```
iex(distributed@princekchaudhari)> KVStore.Store.set("legend", "true")
:ok
```

<br/>

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:4B0082,100:4B0082&height=3" width="100%"/>

<br/>

<sub>Built by <a href="https://github.com/PrinceKChaudhari"><b>PrinceKChaudhari</b></a> · MIT License · Elixir + OTP</sub>

<br/>

![visitors](https://visitor-badge.laobi.icu/badge?page_id=PrinceKChaudhari.kv_store&left_color=0d1117&right_color=4B0082&left_text=visitors)

</div>
