---
title: "Connecting Zotero to AI Assistants via MCP"
date: 2026-02-08
url: "/2026/zotero-mcp-ai"
draft: false
tags: ["Zotero", "AI", "MCP"]
---

If you use [Zotero](https://www.zotero.org/) for managing your research library, you might want to talk to your papers using an AI assistant. The [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) makes this possible — your AI can search, summarize, and analyze your local Zotero library, and if you use a local model, you can do it without uploading anything to third-party servers. Or you can use semantic search with [ZotSeek](https://github.com/introfini/ZotSeek) directly within the Zotero desktop app to resurface relevant papers hidden in your library and get better semantic search when the keyword isn't in the title or abstract.

Disclaimer: to get some of the setup running, I used a debugging session with a chatbot, and a big part of this post was first dictated by me, then converted from speech to text with an open model (Parakeet on MacWhisper), cleaned via chatbot, and finally checked and edited by me (with some additional edits after I received feedback and tried to help some friends with install).

## Why use your own library?

There is a risk of chatbots hallucinating when you work in research — and one of the worst kinds is hallucinated bibliography. The AI just makes up references that don't exist. The best way to limit this is to not rely on internet sources you can't verify, but to ground the conversation in your own bibliography instead. Especially when you've accumulated several thousand papers over your whole research career — sometimes you forget you have something relevant sitting in your library. This tutorial is about chatting with your own curated database of publications. You still need to be careful and verify what the AI says, but you can really limit the risk of total hallucination by grounding it in your own selection of relevant papers. It's useful when the topic you're working on connects to things you already collected — you ask for context and it pulls from what you know is real.

Even with your own library as the source, the AI can still get creative with what it attributes to your papers — it connects things very well, sometimes too well, adding claims that are only loosely present in the original text. Please read carefully and verify any 'discoveries' made by your AI companion :)

## What is free, what costs money

With Zotero MCP, the local part — indexing and searching your library (if you use open-source embeddings) — is completely free. What costs money is AI inference, meaning the chatbot subscription you use to actually have a conversation (Claude, ChatGPT, Mistral, etc.). Similarly, ZotSeek does the retrieval and semantic search part entirely for free and locally — after the initial indexing, it works without any additional computation; you only need to re-index when you add new PDFs to your library (I wrote more details about the setup of it in the last sections of this blogposs)

So in practice: the search/RAG layer is free, the chat layer requires a subscription or your local compute resources. But many of you probably already have one — you'd just use tokens from your existing plan a bit faster.

Personally, I use Claude — the setup is the easiest. But I also wanted to test a European alternative, so I set it up with Mistral Le Chat as well. If you're a student, Mistral has a cheap subscription around €7. The quality is a bit below the latest biggest models from Anthropic or OpenAI, but you can still get a lot of value from it. The Mistral setup is more convoluted though — I figured it out together with Gemini, so I put more details in that section below.

A word on token budgets: if you're on Claude Pro, the bigger models (like Opus with extended thinking) eat through your tokens much faster than Sonnet. In my experience, a Pro subscription gives me roughly 1.5 hours of intensive work with Opus before hitting the limit. The allowance resets every 5 hours, so I plan my work in cycles — a focused session in the morning, then another after the reset, and so on. On a free plan, expect a smaller token budget; also take into account the weekly token budget, otherwise you will quickly hit the wall.

(Edit 2026-02-26) There is always the possibility to work with any tool or model that adheres to and supports MCP standards. I connected to my Zotero via the same MCP while using LM Studio on my Mac and local models (this time Qwen3.5-35B in MLX format, but it should also work with smaller models and other tools). I now do less complex searches or tasks with my local LLM to spare budget for more complex queries in Claude when I need them. There are obviously some limitations, but for clearly defined tasks local inference is pretty useful.

**A word on security:** when using the Mistral/ngrok setup, be careful not to expose your computer to the outside. Always use a password and **do not share your ngrok links** with anyone.

One more thing — there's also [ARIA](https://github.com/lifan0127/ai-research-assistant), a plugin that lets you chat with your PDFs directly inside the Zotero application using your own API keys. It costs additional tokens and I haven't used it much myself, but if you want to stay entirely within Zotero, check it out.

I'm also maintaining a [curated list of useful Zotero plugins](https://github.com/stars/danieltomasz/lists/zotero-plugins) on GitHub — I'll be adding new ones as I discover them.

I also assume you have minimal experience with the command line and Python installation; instead of `uv`, you can install the MCP server via `pipx` or another way to make it available in your environment. This setup is tested on macOS, but in principle it should work on other OSes (I didn't test it; the main difference I can think of might be path handling between OSes).

It will also serve as a reminder for me — every time there is a new ngrok instance, you need to repeat the Mistral setup.

Zotero MCP is available only locally via the Claude desktop app. I am not related to the development of any of these tools — you can always ask me questions, but if you find a bug or something is unclear in the documentation, let the developers know via a GitHub issue (and thank them ;)).

## Install Zotero-MCP

The tool we need is [zotero-mcp](https://github.com/54yyyu/zotero-mcp) ([documentation](https://stevenyuyy.us/zotero-mcp/index.html)). It works with Claude Desktop, ChatGPT, Mistral Le Chat, and other MCP-compatible clients.

### Prerequisites

- **Zotero 7+** running on your computer
- **Python** installed (with `uv` package manager recommended)
- In Zotero: go to **Settings > Advanced** and ensure **"Allow other applications on this computer to communicate with Zotero"** is **checked**

### Install MCP

_Note:_ You can either [install uv](https://docs.astral.sh/uv/getting-started/installation/) directly or with the help of `brew`. `brew` is a community package manager for macOS: <https://brew.sh/>. For both methods, you need to use Terminal. If you haven't used Terminal before, you can open it on Mac with Option + Space and search for "Terminal". The easiest install command is:

```bash
uv tool install zotero-mcp-server
zotero-mcp setup  # Auto-configure (Claude Desktop supported)
```

During the setup you will have occasion to  configure the semantic search.
After setup, initialize your search database:

```bash
# Build with full-text extraction (slower, more comprehensive)
zotero-mcp update-db --fulltext
```

## Optional: Enable Semantic Search

For AI-powered similarity search across your library (beyond basic keyword matching):

```bash
zotero-mcp setup --semantic-config-only
zotero-mcp update-db --fulltext
```

The `--fulltext` flag indexes the full text of your PDFs, which is slower but gives much better results. Without it, only metadata is indexed.

For more details and more options check the github repository of the MCP and [semantic search section](https://github.com/54yyyu/zotero-mcp#-semantic-search).

## Setup for Claude Desktop (recommended)

When you installed and have run  the command

```bash
zotero-mcp setup  # Auto-configure (Claude Desktop supported)
```

you've alreade done that.
This auto-configures your `claude_desktop_config.json`. Restart Claude Desktop and you're done — Zotero tools will appear in your conversation.

If you prefer manual config, add this to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "zotero": {
      "command": "zotero-mcp",
      "env": {
        "ZOTERO_LOCAL": "true"
      }
    }
  }
}
```

## Setup for ChatGPT

According to the MCP documentation, ChatGPT also supports MCP now, but the MCP requires a slightly different configuration:

```bash
uv tool install zotero-mcp-server
zotero-mcp setup --no-claude
```

The `--no-claude` flag creates a standalone configuration optimized for ChatGPT's specific tool naming requirements.

Other option is to use OpenAI codex directly with you installed MCP

```bash
codex mcp add zotero \
  --env ZOTERO_LOCAL=true \
  --env ZOTERO_EMBEDDING_MODEL=default \
  -- /Users/daniel/.local/bin/zotero-mcp
  ```

And the just have conversation in termin in mode `/plan`

## Setup for Mistral Le Chat

Mistral Le Chat supports MCP via remote connectors, which means you need to expose your local MCP server through a secure tunnel. This section covers both the one-time setup and the daily workflow.

**The mental model**: Your Zotero library is a locked room. The MCP Server is the librarian inside. ngrok punches a temporary (or permanent) tunnel through your firewall so Mistral can talk to the librarian.

You will need ngrok installed and authenticated — we cover that first.

### Step 0: Install ngrok and Claim Your Permanent Address

By default, ngrok gives you a random address that changes every time you restart it, which means re-configuring Mistral every day. To avoid this, claim one free permanent domain — you only do this once.

Install ngrok (using the same brew tool as before):

```bash
brew install --cask ngrok
```

Connect your account: Go to ngrok.com, sign up for a free account, and paste the auth command it gives you:

```bash
ngrok config add-authtoken YOUR_PERSONAL_TOKEN_HERE
```

**Optional — Claim a permanent domain:** By default, ngrok gives you a random URL that changes every time you restart it, which means updating Mistral's connector every day. To avoid this, log into your [ngrok Dashboard](https://dashboard.ngrok.com/cloud-edge/domains), click **"Create Domain"**, and copy the free address it gives you (e.g. `fancy-shrimp-1.ngrok-free.app`). This becomes your permanent "phone number."

### Step 1: Start the MCP Server

TThis section assumes you have already installed and configured `zotero-mcp` on your computer using previous step. Open your terminal and run the server in SSE mode:

```bash
uv tool run zotero-mcp serve --transport sse --port 8000
```

Keep this terminal open.

### Step 2: Open a Secure Tunnel

Open a **new** terminal tab and run:

```bash
ngrok http 8000 --basic-auth='admin:your-password'
```

_(Use **single quotes** `'` around the credentials to prevent Zsh errors)_

You will see a deprecation warning — this is expected, the flag still works. Copy the **Forwarding URL** from the output (e.g. `https://xyz-123.ngrok-free.app`).

If you claimed a permanent domain in Step 0, use instead:

```bash
ngrok http 8000 --url=YOUR-DOMAIN.ngrok-free.app --basic-auth='admin:your-password'
```

### Step 3: Get Your Auth Token

Mistral needs your credentials encoded in Base64. Run this in a **third** terminal tab:

```bash
echo -n 'admin:your-password' | base64
```

Copy the output string (e.g. `YWRtaW46eW91ci1wYXNzd29yZA==`).

### Step 4: Configure Mistral Le Chat

Go to [Mistral Le Chat](https://chat.mistral.ai/) > **Connectors** (plug icon) > **+ Add Connector** > **Custom MCP Connector**.

| **Field**          | **Setting**                        | **Note**                                                 |
| ------------------ | ---------------------------------- | -------------------------------------------------------- |
| **Connector Server** | `https://YOUR-NGROK-URL/sse`     | **Must** end in `/sse`                                   |
| **Authentication** | `API Token Authentication`         |                                                          |
| **Header Name**    | `Authorization`                    |                                                          |
| **Header Type**    | `Basic`                            | Select from the dropdown                                 |
| **Header Value**   | `YWRtaW46c2VjcmV0`                 | Paste **only** the Base64 code                           |

Click **Create**.

### Daily Workflow

Every time you want to chat with your papers:

1. Open Terminal → run the **MCP Server** command (Step 1).
2. Open a second tab → run the **ngrok** command (Step 2).
3. Open Mistral and start chatting.

If you set up a permanent domain, you never have to touch the Mistral connector again. If not, you will need to repeat Steps 3 and 4 each time your ngrok URL changes.

### Troubleshooting (Mistral)

- **"404 Not Found"** — You forgot to add `/sse` to the end of the URL.
- **"401 Unauthorized"** — The Base64 string doesn't match the credentials you passed to `--basic-auth`. Re-run the `echo` command and paste the fresh output. Or you typed "Basic" twice (once in the dropdown, once in the text box).
- **"MCP connection requires additional information..."** — Usually a malformed URL or header. Try the nuclear option below.

**The "Nuclear Option":** If the dropdown menus are fighting you, bypass them by putting the credentials directly in the URL. Set Authentication to **None** and URL to: `https://admin:secret@your-ngrok-url.ngrok-free.app/sse`

## Bonus: How to use ZotSeek directly in Zotero?

ZotSeek uses semantic search, which means you can find similar papers by meaning, not just keywords. It is 100% local, and no data leaves your machine.

There is a pretty neat [explanation in the project GitHub README](https://github.com/introfini/ZotSeek#index-your-library), but if you are new to more advanced use of Zotero, you need to:

1. Download the plugin.

- Go to the [project releases page](https://github.com/introfini/ZotSeek/releases) and download the latest file with the `.xpi` extension.

1. Install that extension as a plugin in Zotero via Tools (you can find it in the Zotero menu, on the same level as File, Edit, etc.), then pick `Plugins`. In the upper-right corner, click the small cog button, select `Install plugin from file`, and then enable the plugin via the toggle by its name.

After enabling it, you can play with its settings (you need to go to Zotero settings; the plugin section will be just below the Zotero sections together with other plugins).

![](zotseek_view.png)

I advise first picking the `Abstract only` option for indexing, and automatically indexing new items.
You can also run the "Update index" action (located at the bottom of the settings pane; you will probably need to scroll to it) to index unindexed items in your library.

I did indexing in abstract-only mode — 1 chunk per paper — and 6k papers used 20 MB of disk space and took a bit less than 1 hour to index.

## Other tools worth checking

### MCP for Various scientific engines  search

If you already installed uv for Zotero MCP, another useful companion tool is paper-find-mcp. Instead of searching your own Zotero library, it lets your AI assistant search across external academic sources such as arXiv, PubMed, bioRxiv, medRxiv, IACR, Google Scholar et cetera.

It is available on [PyPI](https://pypi.org/project/paper-find-mcp/) as paper-find-mcp, and the project documents both uv/pip installation and Claude Desktop configuration via an MCP server entry in claude_desktop_config.json.

If you already installed uv to use with Zotero mcp in previous step,  you can easily install this package via:

```bash
uv pip install paper-find-mcp
```

After installing, you  only need to add new mcp defnition to claude config file (the example below), pleasebe careful with correctly closing json brackets.

```bash
open ~/Library/Application Support/Claude/claude_desktop_config.json
```

```json
{
  "mcpServers": {
    "paper_find_server": {
      "command": "uvx",
      "args": ["paper-find-mcp"],
      "env": {
        "SEMANTIC_SCHOLAR_API_KEY": "",
        "CROSSREF_MAILTO": "your_email@example.com",
        "NCBI_API_KEY": "",
        "PAPER_DOWNLOAD_PATH": "~/paper_downloads"
      }
    }
  },
    "preferences": {
      "chromeExtensionEnabled": false,
      "coworkScheduledTasksEnabled": true,
      "sidebarMode": "chat",
      "coworkWebSearchEnabled": true
    }
  }
  ```
