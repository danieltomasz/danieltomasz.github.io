---
title: Linux useful commands
date: 2021-01-30 
draft: true 
description:
tags: 
 -  
---

## Restart gnome

```bash
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
```

## Problem with NVidia card not detecing laptop screen after update
