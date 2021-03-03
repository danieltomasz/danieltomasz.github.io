---
title: Hugo tricks
date: 2021-01-27T00:00:00.000Z
description: "Note to myself how to setup Hugo."
draft: false
featuredImg: ''
tags:
  - hugo
  - setup
---

## How to setup a Hugo page with Github pages and Hugo

My first iteretion of this page used several Jekyll themes. I didn't write much through the years, in 2021 I decided to refresh this site and start writing more often.

Hugo is really popular static site generator. Before Hugo I used Jekyll. Configuring Hugo to use your page on Github is little more complicated than with Jekyll.

Here you could find the [tutorial](https://levelup.gitconnected.com/build-a-personal-website-with-github-pages-and-hugo-6c68592204c7).

First I use `hermit' theme, but then i switched to simple.css. [Here](https://mogwai.be/creating-a-simple.css-site-with-hugo/) you could find more about how to setup it with hugo.

When you use setup with `gh-pages` branch remember to set Jekyll theme (even when your page doesn't use Jekyll).

Adding empty also file `.nojekyll` helps.

Here yuou could find interesting blogpost about [guide to file structure and organisation](https://jpdroege.com/blog/hugo-file-organization/).

## How to make Hugo render drafted content?

[Here](https://kodify.net/hugo/pages/generate-draft-content/) you could find source for this advice/

1. Add option to `config.toml`:

  ```yaml
  title = "Hugo example site"
  baseurl = "https://www.example.com"
  buildDrafts = true
  ```

2. Generate drafted files during the current Hugo build

```bash
hugo server --buildDrafts
```

or

``` bash
hugo server -D
```

To not generate draft content when building our static website, use one of the following command flags:

```bash
hugo --buildDrafts=false
hugo -D=false
hugo -D=F
```
