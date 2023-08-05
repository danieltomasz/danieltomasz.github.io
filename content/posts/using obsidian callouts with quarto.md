---
title: "Obsidian and Quarto callouts"
date: "2023-05-31"
url: "/2023/obsidian-quarto-callouts"
draft: false
tags:
- Quatro
- Obsidian
---
## About callouts

*Disclaimer: Post was originally published as a [public gist](https://gist.github.com/danieltomasz/87b1321e23c045309d2571f525f856cf)*

Callouts are a great way to add more attention ot certain details of the text (in the form of a box).
Quarto provides 5 different types of callouts:

- `note`
- `warning`
- `important`
- `tip`
- `caution`.

The color and icon will be different depending upon the type that you select.
You could preview them in the official documentation - [Quarto - Callout Blocks](https://quarto.org/docs/authoring/callouts.html).
If you want to check the end effect jump directly to it [here](https://gist.github.com/danieltomasz/87b1321e23c045309d2571f525f856cf#comparison/).

### The problem:

When writing your text directly in markdown compiled in Quarto you need to use pandoc `div` syntax

``` markdown
::: {.callout-note}
Note that there are five types of callouts, including:
`note`, `warning`, `important`, `tip`, and `caution`.
:::
```

When you want to edit your text in Obsidian obisidian doesn't pick the pandoc `div` syntax, instead it will have:

``` markdown
> [!note] My note
>
> Note content
```

Edit on July 2023: Github also introduced callouts with the same syntax under name of [Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts)

**There is no easy way to have nice formatted callouts in qmd/md files in Obsidian before compiling them to pdf/html**

## Lua filters come as a solution

Pandoc can be supplemented by filters written by Lua that might some complex operations with source text.

I found a nice pandoc filter on the Obsidian forum, which I modified, so it support the default callouts in Quarto.
You need to save it as a pandoc filter and put inro your project folder and point to it when running quarto command (either via commandline or by putting it into you `_quart.yml` project settings.

In my case, I created `obsidian-callouts.lua` in `filters` folder and I point to it in the `_quarto,yml` in the root of the folder in the following section (I excluded irrelevant details):

``` yml
project:
  output-dir: _output
filters:
- filters/obsidian-callouts.lua
```

Content of the file `obsidian-callouts.lua` :

``` lua
local stringify = (require "pandoc.utils").stringify

function BlockQuote (el)
    start = el.content[1]
    if (start.t == "Para" and start.content[1].t == "Str" and
        start.content[1].text:match("^%[!%w+%][-+]?$")) then
        _, _, ctype = start.content[1].text:find("%[!(%w+)%]")
        el.content:remove(1)
        start.content:remove(1)
        local class = "callout-" .. ctype:lower()
        div = pandoc.Div(el.content, {class = class})
        div.attributes["data-callout"] = ctype:lower()
        div.attributes["title"] = stringify(start.content):gsub("^ ", "")
        return div
    else
        return el
    end
end
```

As a source I used this thread from Obsidian forum[^1]

[^1]: https://forum.obsidian.md/t/rendering-callouts-similarly-in-pandoc/40020/6

### Tweaks to obsidian CSS

By default Obsidian recognize only `note` and `warning` callouts, to have the other 3 callouts the same icons and colors as in Quarto add the following CSS snippet `quarto-callout-styllling` to hidden `.snippets` folder and turn it on in the Obsidian appearance section of settings

``` css
/* See https://lucide.dev for icon codes */

/* annotation */
.callout[data-callout="important"] {
  --callout-color: 251, 70, 76;
  --callout-icon: lucide-alert-circle
}

.callout[data-callout="tip"] {
  --callout-color: 28, 207, 110;
  --callout-icon: lucide-lightbulb
}

.callout[data-callout="caution"] {
  --callout-color: 255,153,102;
  --callout-icon: lucide-flame
}
```

### Comparison

After applying the css could see the difference between callouts in Live Preview in Obsidian

![Image](https://user-images.githubusercontent.com/7980381/242414671-abd8b360-3a98-4fa0-90ea-d62c453855f0.png)

and PDF generated via Quarto

![Image](https://user-images.githubusercontent.com/7980381/242414991-78ff1f8b-e361-400e-a664-2599f7867c1d.png)

Below is the markdown used to generate it

``` markdown

> [!note] My note
>
> Note content

> [!warning] My note
>
> Note content

> [!important] My note
>
> Note content

> [!tip] My note
>
> Note content

> [!caution] My note
>
> Note content
```

### Attention !

While those snippets will ensure that your notes will render nicely in Obsidian, it may cause other editors that support (only about people) Quarto to offer the same (altough) it will compile nicely to pdf/html.

I didn't extensively test this Lua filter, so it might easily go broke in more complex cases and if you will try to use the callouts outside the one defined in Quarto by default.

### More about how to use Quarto in Obsidian

In general, I enabled Obsidian to see quarto files as md files via plugin, and then use `obsidian-shellcomands` with `quarto render {{file_path:absolute}} --to pdf` to render the file inside Obsidian (you can install quarto via installer from website, or homebrew on MacOS)

I also assigned this shellcomand to a button in my GUI via `commander` plugin (so I dont need to invoke it every time via command switcher when I want to re-run it on a file.

I created rudimentary plugin to support QMD files in Obsidian, in the `Readme.md` you could find more advices how to streamline work with your qmd files in Quarto[^2].

[^2]: [danieltomasz/qmd-as-md-obsidian: A plugin for Obsidian which allows editing of `qmd` Quarto files.](https://github.com/danieltomasz/qmd-as-md-obsidian)