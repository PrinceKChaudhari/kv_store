<div align="center">
<img src="https://capsule-render.vercel.app/api?type=rect&color=0:ff0000,100:ff0000&height=5" width="100%"/>
</div>

<br/>

<div align="center">

```
██████╗ ██╗   ██╗██╗██╗     ██████╗     ██╗  ██╗██╗   ██╗
██╔══██╗██║   ██║██║██║     ██╔══██╗    ██║ ██╔╝██║   ██║
██████╔╝██║   ██║██║██║     ██║  ██║    █████╔╝ ██║   ██║
██╔══██╗██║   ██║██║██║     ██║  ██║    ██╔═██╗ ╚██╗ ██╔╝
██████╔╝╚██████╔╝██║███████╗██████╔╝    ██║  ██╗ ╚████╔╝
╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═╝  ╚═╝  ╚═══╝
```

<img src="https://readme-typing-svg.demolab.com?font=Ubuntu+Mono&size=14&duration=1500&pause=800&color=FF0000&center=true&width=600&lines=Distributed.+Fault-tolerant.+Merciless.;SET.+GET.+REPLICATE.+SURVIVE.;Built+in+Elixir.+Powered+by+the+BEAM.;What+WhatsApp+runs+on.+Now+in+your+hands."/>

<br/>

![](https://img.shields.io/badge/ELIXIR-1.14+-FF0000?style=flat-square&labelColor=000000)
![](https://img.shields.io/badge/ERLANG_OTP-25+-FF0000?style=flat-square&labelColor=000000)
![](https://img.shields.io/badge/LINES-300+-FF0000?style=flat-square&labelColor=000000)
![](https://img.shields.io/badge/STATUS-RUNNING-FF0000?style=flat-square&labelColor=000000)

</div>

<br/>

---

<br/>

<div align="center">

> # *"Crash. Restart. Keep running.*
> # *That's not a bug.*
> # *That's Erlang OTP."*

</div>

<br/>

---

<br/>

<table>
<tr>
<td width="50%" valign="top">

### What it does.

```
SET  "user:1"  →  "Prince"   ✓
GET  "user:1"  →  "Prince"   ✓
DEL  "user:1"  →  gone       ✓
```

A key-value store.  
Simple interface.  
Distributed underneath.  
**Survives node crashes.**

One node dies?  
**The others keep running.**  
Your data stays alive.

</td>
<td width="50%" valign="top">

### Why it's brutal.

```
Node 1  ──────────────┐
Node 2  ──────────────┤  ALL IN SYNC
Node 3  ──────────────┘

Node 1 crashes?

Node 2  ──────────────┐
Node 3  ──────────────┘  STILL RUNNING
```

**No single point of failure.**  
**No data loss.**  
**No mercy for downtime.**

</td>
</tr>
</table>

<br/>

---

<br/>

## `ps aux` — Components

```
  PID   COMPONENT               DESCRIPTION
  ────────────────────────────────────────────────────────────
  001   KVStore.Store           GenServer — in-memory hashmap
  002   KVStore.Router          HTTP API  — GET/POST/DELETE
  003   KVStore.Replicator      Erlang RPC — sync to peers
  004   KVStore.Application     OTP Supervisor — never dies
  ────────────────────────────────────────────────────────────
        Supervised by OTP. Crash one. Rest survive.
```

<br/>

---

<br/>

## `curl` — API

<details>
<summary><b>▶ &nbsp; Expand all endpoints</b></summary>

<br/>

```bash
# SET
curl -X POST http://localhost:4000/store/name \
  -H "Content-Type: application/json" \
  -d '{"value": "Prince"}'

# GET
curl http://localhost:4000/store/name
# → {"key":"name","value":"Prince"}

# DELETE
curl -X DELETE http://localhost:4000/store/name

# ALL KEYS
curl http://localhost:4000/keys

# STATS
curl http://localhost:4000/stats

# ADD PEER NODE
curl -X POST http://localhost:4000/peers \
  -H "Content-Type: application/json" \
  -d '{"node": "kv@192.168.1.2"}'
```

</details>

<br/>

---

<br/>

## `./run.sh` — Start

```bash
git clone https://github.com/PrinceKChaudhari/kv_store.git
cd kv_store
mix deps.get
mix run --no-halt
# → http://localhost:4000
```

> [!NOTE]
> Works on Linux, macOS, and Termux (Android 📱)

<br/>

---

<br/>

## `iex -S mix` — Shell

```elixir
KVStore.Store.set("name", "Prince")    # :ok
KVStore.Store.get("name")              # "Prince"
KVStore.Store.keys()                   # ["name"]
KVStore.Store.stats()                  # %{keys: 1, ops: 2}
KVStore.Store.flush()                  # :ok
```

<br/>

---

<br/>

## Architecture

```
  ┌─────────────────────────────────────────────────────┐
  │                   HTTP CLIENT                       │
  └────────────────────────┬────────────────────────────┘
                           │
                           ▼
  ┌─────────────────────────────────────────────────────┐
  │           Plug.Cowboy  +  KVStore.Router             │
  └──────────────┬──────────────────────────────────────┘
                 │
       ┌─────────┴──────────┐
       ▼                    ▼
  ┌─────────┐        ┌─────────────────┐
  │  Store  │        │   Replicator    │
  │GenServer│        │  → Node 2 RPC   │
  │         │        │  → Node 3 RPC   │
  └─────────┘        └─────────────────┘
       │
  OTP Supervisor — crash & restart automatically
```

<br/>

---

<br/>

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:ff0000,100:ff0000&height=5" width="100%"/>

<br/>

```
[✓] Store running
[✓] Replicator running
[✓] HTTP server running
[✓] Ready to take everything you throw at it.
```

<br/>

<sub>Built by <a href="https://github.com/PrinceKChaudhari"><b>PrinceKChaudhari</b></a> · MIT · Elixir + OTP</sub>

<br/>

![visitors](https://visitor-badge.laobi.icu/badge?page_id=PrinceKChaudhari.kv_store&left_color=000000&right_color=ff0000)

</div>
