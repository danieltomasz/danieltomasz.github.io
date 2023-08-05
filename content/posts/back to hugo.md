---
title: "From Quarto back to Hugo"
description: "Why I switched from Quarto to Hugo  - some thoughts on my blogging setup"
date: "2023-08-03"
draft: false
summary: Why I switched  back to Hugo from Quarto
tags:
- Quatro
- Hugo
---

I am using the Hugo lines theme, you can find it [here](https://github.com/ronv/lines).

## Hugo and Github pages

There is nice tutorial here: https://gohugo.io/hosting-and-deployment/hosting-on-github/.
But my workflow was failing.
I add the theme as submodule, but I noticed that  somehow `.gitmodules` file was not added to the repository.
Because of that, I had to add it manually:

```toml
[submodule "themes/lines"]
	path = themes/lines
	url = https://github.com/ronv/lines.git
```

## Hugo, Quarto and my history of using static site generators.

Long ago I was experimenting with Jekyll (you can see one of the pages I created [here](https://brainhackwarsaw2017.github.io/)), then Hugo and a year ago I switched to Quarto.
Quarto is great for scientific publications, but I find it too limiting for a blog.

The structure of the blog require you to put every of your posts into its own folder with `index.qmd` file.

This is great for showcasing of your blog, but it is not very convenient for writing.
I am using Pandoc/Quarto almost anywhere I can, but I as the project primary goal is to be a scientific publishing tool, 
the blog part will be always a bit of an afterthought. To give the justice to the team, given their limited resources, they are great with fast fixing bug and adding new features. There are nice things planned, like a support (only about people) for `slug` and permalinks ([here](https://github.com/quarto-dev/quarto-cli/issues/6422)) but they don't land there soon.
It was a bit of point of friction for me, so I decided to change it and returned to Hugo as static site generator.

Fortunately, in a world of static site generators, there is a “free lunch”.
I can have posts with executable R and Python code, and I can have a blog with a nice structure.
Quarto can render from a markdown `qmd` format to Markdown with Hugo syntax.
You can find more how to set up Hugo with Quarto official page](https://quarto.org/docs/output-formats/hugo.html).

A quick tour of my setup (you can find the same information on Quarto pages):

I added this to my `config.toml` file:

```toml
ignoreFiles = [ "\\.qmd$", "\\.ipynb$", "\\.py$" ]

[markup]
  defaultMarkdownHandler = "goldmark"
  [markup.goldmark.renderer]
    unsafe = true
``````

I have a `content/posts` folder with all my posts. Inside it I have a subfolder for folders with `Quarto`, with `index.qmd` file.

I put this `_quarto.yml` file in the root of my Hugo project:

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

Every time I want to publish a post written in `qmd` files, I run `quarto render` in the root of my Hugo project.
I am thinking about adding this to my `Makefile` to make it even easier.

I also found two nice blog posts from people using Quarto with Hugo:

- [🪄 Quarto, Hugo, Apero | Cédric Batailler](https://cedricbatailler.me/blog/2022-apero/). Cédric is using lovely Apero theme. I am finding this theme great, but I choose to stick with  minimalism of lines theme.
- [Setting up a Hugo Website with Quarto | Paul Johnson](https://www.paulrjohnson.net/2022/09/setting-up-a-hugo-website-with-quarto/). Paul is using a PaperMod theme, which is also very nice. He is a bit more technical in his post.

Fun fact: After using Quarto for a year, I sometimes still need to check if it is _Quarto_ or _Quatro_ (I made such mistake in the beginning of this post :)).

As per wikipedia entry[^1]:

>A quarto (from Latin quārtō, ablative form of quārtus, fourth) is a book or pamphlet made up of one or more full sheets of paper on which 8 pages of text were printed, which were then folded two times to produce four leaves.

I am stillclose to original meaning, even when I misspell it (_quatro_ means _four_ in Portuguese and Italian).

[^1]: [Quarto - Wikipedia](https://en.wikipedia.org/wiki/Quarto)