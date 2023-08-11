---
title: "From Quarto back to Hugo"
description: "Why I switched from Quarto to Hugo  - some thoughts on my blogging setup"
date: "2023-08-03"
lastmod:
draft: false
summary: Why I switched  back to Hugo from Quarto
tags:
- Quatro
- Hugo
---

## Hugo, Quarto and my history of using static site generators.

Long ago I was experimenting with Jekyll (you can see one of the pages I created [here](https://brainhackwarsaw2017.github.io/)), then I was trying Hugo and a year ago I switched to Quarto.
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

## Customizing the theme

I started from the  lines theme, you can find it [here](https://github.com/ronv/lines).
Later I mixed it with another theme, [simplist](https://github.com/ronv/simplist) by the same author and I added my custom CSS parts.

### Hugo and GitHub pages

There is nice tutorial here: https://gohugo.io/hosting-and-deployment/hosting-on-github/.
But my workflow was failing.
I added the theme as submodule, but I noticed that somehow `.gitmodules` file isn't in the repository.
Because of that, I had to add it manually to my `.gitmodules` file.
Then I noticed that because of the theme is shipping with example content, it is adding a lot of _lorem ipsum_ posts to published version.
I forked the theme and removed the example content. The finale version of my `.gitmodules` file looks like this:

```toml
[submodule "themes/lines"]
    path = "themes/lines"
    url = "https://github.com/danieltomasz/lines.git"
```

### Hugo and code highlighting

To get code highlighting in backticks markdown fences I enabled:

```toml
pygmentsStyle = "pygments"
pygmentsCodefences = true
```

I was trying to get code numbering and a separate code that is easy to copy.
I try this setting within the markup section,

```toml
  [markup.highlight]
    linenos = true
    lineNumbersInTable = true
```

 but the line numbers section were two lines short than the code section (the code section was customized by the theme `scss`).
 I will try to fix it later.

### Rendering mermaid diagrams

Paul Johnson describe his setup in [this blogpost](https://www.paulrjohnson.net/2022/09/rendering-mermaid-diagrams-on-a-hugo-website-using-quarto/).


### Adding comments with `giscus`

I followed various blogpost with the configuration advices.
By default, `giscus` is adding comments to every page, but I wanted to have comments only on my posts.
I followed advice[^2] and  I wrapped my addition of `giscus` partial into `footer.html` with `if` statement:

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

Some other useful links: https://www.brycewray.com/posts/2022/05/tips-using-giscus/

### Date of last edit directly from github

Some advice how to set up it: [Add a Last Edited Date to Posts · Make with Hugo](https://makewithhugo.com/add-a-last-edited-date/).

One caveat: setting `enableGitInfo` to `true` in your site’s configuration file is not enough[^3]. You have to add `--enableGitInfo` to get `.GitInfo`:

```bash
hugo serve --enableGitInfo
```

[^3]: [Add git commit date as last update date in hugo page](https://djangocas.dev/blog/add-git-commit-date-as-last-update-date-in-hugo-page/)