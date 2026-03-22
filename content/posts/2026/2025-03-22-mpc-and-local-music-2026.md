---
title: "Listening to Local Music with MPD on Mac in 2026"
date: 2026-03-07
tags: ["mpd", "music"]
draft: false
---


In the era of streaming, I am returning to my local library of ripped CDs and Bandcamp albums. Going back to local is not (only) about rejecting streaming (check `Mood Machine` by Liz Pelly, which describes some of the wrongdoing of the industry), but more about better regulating your environment in the attention economy.

I was once a very avid listener and follower of blogs, recommendations from peers (kudos to `niekomercyjni muzyczni laicy`), and in general my own exploration. But at some point, maybe due to lack of time and energy, I started relying almost completely on Spotify to tell me what to listen to from my own library or its recomendation. While it was handy, the recommendations became really similar, and the UI mostly surfaced only the latest listened playlists and albums. It became hard to make a distinction between my library and their recommendations. I ended up listening to much less of much more homogeneous music.

The renaissance came when I rediscovered album views. First I read on an app proposing rethinking Apple Music (I weren't subscriber), but then I found a similar interface for a local library via MPD, first Persephone, then Rigelian. Interfaces matter more than I expected here. With a local or remote library, a good client is not just a remote control but part of how the collection appears to you. Cover views, album browsing, and even small bits of friction change what I end up listening to.

Spotify may still be nice in terms of convenience and availability of albums, setting apart the controversies, but resurfacing older music or albums is much harder there. Also, more and more Spotify and other streaming services move away from the concept of the album toward playlists. That makes sense sometimes, but I still miss the artistic completeness of albums. As a person renting a house abroad and moving often, I am still not prepared to start amassing a collection of vinyl or cassettes, so I need to focus on digital. And digital still offers a lot.

I like that this setup can bring back albums I have not played in years. A local library can easily become too large and too familiar at the same time, where I mostly return to the same small corner of it. Randomizing album playback is a simple way to make the collection feel wider again, and it can still bring surprise and wonder :)

I was a long-time ago a Foobar2000 user, but a while back I switched to MPD and various interfaces. On Mac and iOS, I used to enjoy Persephone for its nice cover view, though it is no longer supported since development ceased. Right now I really like Rigelian. It is written in Swift, offers a lovely album view, and has the potential to resurface random albums. It also recently received a major update with a new interface.

 MPD is a solution for that, and its biggest advantage is its extendability via players and the fact that it does not get in your way when you need something minimal.  Rigelian is really nice, but I often prefer just to listen to music in my terminal. Sometimes I still use ncmpcpp as a command-line client, but recently I switched to `rmpc`. It is like `ncmpcpp`, but it offers a nice cover view out of the box, at least in the `ghostty` terminal. The latest release from February 2026 has a bug preventing it from displaying covers in `iTerm`, though this was fixed on `main` and has not yet been released. I tried to make covers available in `ncmpcpp`, but on Mac it seems to be a bit harder than on Linux, so I gave up :)

TTo keep my metadata clean and download covers I am using [Mp3tag](https://www.mp3tag.de/en/).

P.S. I still scrobble music on Last.fm, and many of my friends do too. I have been doing this since 2008, although I created a new account in 2011 and had a few years off from more active music listening practices in between. I remember the time when Last.fm felt more like a social network; now it is only a shadow of its former glory. Call me old-school, but I really enjoy documenting my listening practices, not only on Last.fm but also on Rate Your Music. It is also still a great way to peek at what your friends are listening to and what albums to try next, especially lists on Rate Your Music(the lists were hot there long before Letterboxd). Scrobbling still gives a kind of continuity to my listening, even when the software around it changes.

## A bit of technical setup

I installed `mpdscribble` to enable scrobbling via MPD. There is also a handy command to restart services, since I installed `mpd` and `mpdscribble` via Homebrew:

```bash
brew services restart  mpd mpdscribble
brew services stop  mpd mpdscribble

```

When I add new albums or move them between folders, for refreshing the local mpd database I use:

```bash
mpc update --wait
```

As I wrote before, one thing I have been thinking about is how much choice I have in my library, and how often that makes my attention switch too quickly. There are too many albums to choose from, so I decided to randomize the process a bit and make it easier to return to records I might otherwise overlook.

Rigelian offers random albums out of the box, but when I am listening in the terminal, I am using a small script added to my .zshrc to cache albums, pick one at random, and keep a short history so I can replay earlier picks.

My MPD settings in `~/.mpd/mpd.conf` look like this:

```conf
bind_to_address "127.0.0.1"
bind_to_address "::1"
#bind_to_address "/Users/daniel/.config/mpd/socket"
port "6600"

audio_buffer_size "8192"
buffer_before_play "25%"

music_directory  "/Users/daniel/Music/Moja muzyka"
audio_output {
    type "osx"
    name "Mac Output"
    mixer_type "software"
    audio_output_format "44100:16:2"

}
```

```bash

album_cache_file="$HOME/.cache/mpd-albums.tsv"
album_history_file="$HOME/.cache/mpd-last-album.tsv"


rebuild_album_cache() {
  mkdir -p "${album_cache_file:h}"

  mpc -f '[[%albumartist%]|[%artist%]]\t[%album%]' search '(album != "")' |
    awk -F '\t' 'NF >= 2 && $1 != "" && $2 != "" && !seen[$1 FS $2]++ { print $1 FS $2 }' \
    > "$album_cache_file"

  printf 'Cached %s albums\n' "$(wc -l < "$album_cache_file" | tr -d ' ')"
}

random_album_cached() {
  [ -s "$album_cache_file" ] || rebuild_album_cache

  local choice artist album
  choice="$(
    python3 - "$album_cache_file" <<'PY'
import random, sys, pathlib
p = pathlib.Path(sys.argv[1])
rows = [line.rstrip("\n") for line in p.read_text(encoding="utf-8").splitlines() if line.strip()]
print(random.choice(rows) if rows else "", end="")
PY
  )"

  [ -z "$choice" ] && { echo "No albums found."; return 1; }

  artist=${choice%%$'\t'*}
  album=${choice#*$'\t'}

  printf 'Playing: %s — %s\n' "$artist" "$album"
  mpc clear
  mpc findadd albumartist "$artist" album "$album" || \
  mpc findadd artist "$artist" album "$album"
  printf '%s\t%s\n' "$artist" "$album" >> "$album_history_file"
  mpc play
}

# Updated replay function
replay_album() {
  [ -s "$album_history_file" ] || { echo "No album history."; return 1; }
  local n=${1:-1} total line artist album
  total=$(wc -l < "$album_history_file" | tr -d ' ')
  (( n > total )) && n=$total
  line=$(tail -n "$n" "$album_history_file" | head -n 1)
  artist=${line%%$'\t'*}
  album=${line#*$'\t'}
  printf 'Replaying (%d ago): %s — %s\n' "$n" "$artist" "$album"
  mpc clear
  mpc findadd albumartist "$artist" album "$album" || \
  mpc findadd artist "$artist" album "$album"
  mpc play
}
alias rra='replay_album'
alias ra='random_album_cached'
```
