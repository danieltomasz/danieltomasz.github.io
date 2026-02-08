---
title: "Connecting Zotero to AI Assistants via MCP"
date: 2026-02-08
url: "/2026/zotero-mcp-ai"
draft: false
tags: ["Zotero", "AI", "MCP"]
---

If you use [Zotero](https://www.zotero.org/) for managing your research library, you might want to talk to your papers using an AI assistant. The [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) makes this possible — your AI can search, summarize, and analyze your local Zotero library without uploading anything to third-party servers. Or you can use semantic search with [ZotSeek](https://github.com/introfini/ZotSeek) to resurface your hidden relevant paper and have better semantic search when the keyword isn't in the title or abstract.
I did indexing in the abstract mode only — 1 chunk per paper — 6k papers use 20MB disc space and took a bit less than 1 hour to index.

Disclaimer: to get some of the setup running I used debugging session with chatbot, and the big part of the content of the post was first dictated by me, then via open model to text (Parakeet on MacWhisper) and cleaned via chatbot, and finally checked and edited by me.

## Why use your own library?

There is a risk of chatbots hallucinating when you work in research — and one of the worst kinds is hallucinated bibliography. The AI just makes up references that don't exist. The best way to limit this is to not rely on internet sources you can't verify, but to ground the conversation in your own bibliography instead. Especially when you've accumulated several thousand papers over your whole research career — sometimes you forget you have something relevant sitting in your library. This tutorial is about chatting with your own curated database of publications. You still need to be careful and verify what the AI says, but you can really limit the risk of total hallucination by grounding it in your own papers. It's useful when the topic you're working on connects to things you already collected — you ask for context and it pulls from what you know is real.

## Cost and setup

With Zotero MCP, the local part — indexing and searching your library (if you use open source embeddings) — is completely free. What costs money is the AI inference, meaning the chatbot subscription you use to actually have a conversation (Claude, ChatGPT, Mistral, etc.). Similarly, ZotSeek does the retrieval and semantic search part entirely for free and locally — after the initial indexing, it works without any additional computation, you only need to re-index when you add new PDFs to your library.

So in practice: the search/RAG layer is free, the chat layer requires a subscription. But many of you probably already have one — you'd just use tokens from your existing plan a bit faster.

Personally, I use Claude — the setup is the easiest. But I also wanted to test a European alternative, so I set it up with Mistral Le Chat as well. If you're a student, Mistral has a cheap subscription around €7. The quality is a bit below the latest biggest models from Anthropic or OpenAI, but you can still get a lot of value from it. The Mistral setup is more convoluted though — I figured it out together with Gemini, so I put more details in that section below.

**A word on security:** when using the Mistral/ngrok setup, be careful not to expose your computer to the outside. Always use a password and **do not share your ngrok links** with anyone.

One more thing — there's also [ARIA](https://github.com/lifan0127/ai-research-assistant), a plugin that lets you chat with your PDFs directly inside the Zotero application using your own API keys. It costs additional tokens and I haven't used it much myself, but if you want to stay entirely within Zotero, check it out.

I'm also maintaining a [curated list of useful Zotero plugins](https://github.com/stars/danieltomasz/lists/zotero-plugins) on GitHub — I'll be adding new ones as I discover them.

I also assume you have minimal experience with command line and Python installation; instead of `uv` you can install the MCP server via `pipx` or other way to make it available to your environment. This setup is tested on macOS, but it should work on other OSes. It will also serve as a reminder for me — every time there is a new ngrok instance you need to repeat the Mistral setup. Claude Zotero MCP is available only locally via the Claude desktop app. I am not related to development of any of these tools — you can always ask me questions, but if you find a bug or something is not clear in the documentation, let the developers know via GitHub issue (and thank them ;)

## Install Zotero-MCP

The tool we need is [zotero-mcp](https://github.com/54yyyu/zotero-mcp) ([documentation](https://stevenyuyy.us/zotero-mcp/index.html)). It works with Claude Desktop, ChatGPT, Mistral Le Chat, and other MCP-compatible clients.

### Prerequisites

- **Zotero 7+** running on your computer
- **Python** installed (with `uv` package manager recommended)
- In Zotero: go to **Settings > Advanced** and ensure **"Allow other applications on this computer to communicate with Zotero"** is **checked**

### Install

```bash
uv tool install "git+https://github.com/54yyyu/zotero-mcp.git"
```

## Setup for Claude Desktop (recommended)

The simplest path. Just run:

```bash
zotero-mcp setup
```

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

ChatGPT also supports MCP now, but requires a slightly different configuration:

```bash
pip install git+https://github.com/54yyyu/zotero-mcp.git
zotero-mcp setup --no-claude
```

The `--no-claude` flag creates a standalone configuration optimized for ChatGPT's specific tool naming requirements.

## Setup for Mistral Le Chat

Mistral Le Chat supports MCP via remote connectors, which makes the setup more involved — you need to expose your local MCP server through a secure tunnel using `ngrok`.

You will additionally need **ngrok** installed and authenticated.

### Step 1: Start the MCP Server

Open your terminal and run the server in SSE (Server-Sent Events) mode:

```bash
uv tool run zotero-mcp serve --transport sse --port 8000
```

Keep this terminal open.

### Step 2: Open a Secure Tunnel

Open a **new** terminal tab. Protect the tunnel with a password so the public cannot access your library.

_(Use **single quotes** `'` around the credentials to prevent Zsh errors)_

```bash
ngrok http 8000 --basic-auth='admin:secret'
```

Replace `admin:secret` with your own username:password if desired. **Copy the Forwarding URL** from the screen (e.g., `https://xyz-123.ngrok-free.app`).

### Step 3: Get Your Auth Token

Mistral needs your password encoded in Base64. Run this in a **third** terminal tab:

```bash
echo -n 'admin:secret' | base64
```

**Output Example:** `YWRtaW46c2VjcmV0` — copy the string from your console.

### Step 4: Configure Mistral Le Chat

Go to [Mistral Le Chat](https://chat.mistral.ai/) > **Connectors** (plug icon) > **+ Add Connector** > **Custom MCP Connector**.

| **Field**          | **Setting**                        | **Note**                                                 |
| ------------------ | ---------------------------------- | -------------------------------------------------------- |
| **Connector Server** | `https://YOUR-NGROK-URL/sse`     | **Must** end in `/sse`                                   |
| **Authentication** | `API Token Authentication`         |                                                          |
| **Header Name**    | `Authorization`                    |                                                          |
| **Header Type**    | `Basic`                            | Select from the dropdown                                 |
| **Header Value**   | `YWRtaW46c2VjcmV0`                | Paste **only** the Base64 code

Click **Create**.

### Troubleshooting (Mistral)

- **"404 Not Found"** — You forgot to add `/sse` to the end of the URL.
- **"401 Unauthorized"** — The Base64 code is wrong, or you typed "Basic" twice (once in the dropdown, once in the text box).
- **"MCP connection requires additional information..."** — Usually a malformed URL or header. Try the nuclear option below.

**The "Nuclear Option":** If the dropdown menus are fighting you, bypass them by putting the credentials directly in the URL. Set Authentication to **None** and URL to: `https://admin:secret@your-ngrok-url.ngrok-free.app/sse`

## Optional: Enable Semantic Search

For AI-powered similarity search across your library (beyond basic keyword matching):

```bash
zotero-mcp setup --semantic-config-only
zotero-mcp update-db --fulltext
```

The `--fulltext` flag indexes the full text of your PDFs, which is slower but gives much better results. Without it, only metadata is indexed.
