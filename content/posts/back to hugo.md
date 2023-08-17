---
title: "From Quarto with love (but back to Hugo)"
description: "Why I switched from Quarto to Hugo  - some thoughts on my blogging setup"
date: "2023-08-03"
lastmod:
draft: false
summary: Why I switched  back to Hugo from Quarto
tags:
- Quatro
- Hugo
- Blogging
---

I've been using different static site generators over the years - Jekyll, Hugo, and most recently Quarto. In this post I'll share my experiences and how I'm now using Hugo and Quarto together for my blog.

# Why I Switched back to Hugo

I used Jekyll years ago (you can see one of the pages I created [here](https://brainhackwarsaw2017.github.io/)), then switched to Hugo, and about a year ago I started using Quarto.

**Quarto** is great for scientific publishing, but I found it too limiting for a personal blog:

- Every post must be in its own folder with an `index.qmd` file. This works well for showcasing content, but isn't convenient for writing.
- As a scientific publishing tool, the blog features remain an afterthought. The Quarto team is great about adding features, but blog improvements happen slowly.

So I decided to switch back to **Hugo** as my static site generator for the flexibility.

Fortunately, there's no need to fully abandon Quarto. [Quarto has built-in support for outputting to Hugo](https://quarto.org/docs/output-formats/hugo.html). I can use Quarto to render my posts written in `qmd` format into Markdown that Hugo can use.

# Quarto Loves Hugo

Here is a quick overview of how I have Hugo and Quarto working together:

- I added some config settings to my Hugo `config.toml` file:

```toml
ignoreFiles = [ "\\.qmd$", "\\.ipynb$", "\\.py$" ]

[markup]
  defaultMarkdownHandler = "goldmark"
  [markup.goldmark.renderer]
    unsafe = true
``````

- I have a `content/posts` folder containing subfolders for each post, with a `index.qmd` file inside.
	
- I put this `_quarto.yml` in the Hugo root directory:

```yaml
project:
  type: hugo
format:
  hugo-md:
    code-fold: true
    html-math-method: webtex
execute:
  warning: false
```

- To create post written in `qmd` files, I run `quarto render` which outputs Markdown from my `qmd` posts into the Hugo content folder.

I also found two nice blog posts from people using Quarto with Hugo:

- [🪄 Quarto, Hugo, Apero | Cédric Batailler](https://cedricbatailler.me/blog/2022-apero/). Cédric is using lovely Apero theme. I am finding this theme great, but I choose to stick with minimalism of lines theme.
- [Setting up a Hugo Website with Quarto | Paul Johnson](https://www.paulrjohnson.net/2022/09/setting-up-a-hugo-website-with-quarto/). Paul is using a PaperMod theme, which is also very nice. He is a bit more technical in his post
- Paul Johnson describe how he render mermaid diagrams (supported in Quarto) in [this blogpost](https://www.paulrjohnson.net/2022/09/rendering-mermaid-diagrams-on-a-hugo-website-using-quarto/).

# Customizing the Theme

I started from the lines theme, you can find it [here](https://github.com/ronv/lines).  
Later I mixed it with another theme, [simplist](https://github.com/ronv/simplist) by the same author and I added my custom CSS parts.

# More Customisation

I started with the Lines theme, customised it with styles from the Simplist theme, and added some of my own CSS.

## Hugo and GitHub Pages

I followed [Hugo's GitHub Pages guide](https://gohugo.io/hosting-and-deployment/hosting-on-github/) but ran into some issues:

- The theme submodule wasn't syncing properly. I had to manually add the `.gitmodules` file.
- The theme's example content was cluttering my published site. I forked the theme and removed the examples.

Here is my final `.gitmodules` file:

```toml
[submodule "themes/lines"]
    path = "themes/lines"
    url = "https://github.com/danieltomasz/lines.git"
```

## Hugo and Code Highlighting

To get code highlighting in backticks markdown fences I enabled:

```toml
pygmentsStyle = "pygments"
pygmentsCodefences = true
```

## Adding Comments with `giscus`

I followed various blogpost with the configuration advices.  
By default, `giscus` is adding comments to every page, but I wanted to have comments only on my posts.  
I followed advice[^2] and I wrapped my addition of `giscus` partial into `footer.html` with `if` statement:

```hugo
{{ if not .Params.noComment }}
    {{ partial "giscus" . }}
{{ end }}
```

When I don't want to include a comments block, I am adding this in the frontmatter of the post (yaml):

```yaml
noComment: true
```

[^2]: [How to disable comments in specific pages? - support - HUGO](https://discourse.gohugo.io/t/how-to-disable-comments-in-specific-pages/22177/2)

Some other useful links: <https://www.brycewray.com/posts/2022/05/tips-using-giscus/>

## Date of Last Edit Directly from Github

Some advice how to set up it: [Add a Last Edited Date to Posts · Make with Hugo](https://makewithhugo.com/add-a-last-edited-date/).

One caveat: setting `enableGitInfo` to `true` in your site’s configuration file sometimes is not enough[^3]. You have to add `--enableGitInfo` to get `.GitInfo`:

```bash
hugo serve --enableGitInfo
```

[^3]: [Add git commit date as last update date in hugo page](https://djangocas.dev/blog/add-git-commit-date-as-last-update-date-in-hugo-page/)
