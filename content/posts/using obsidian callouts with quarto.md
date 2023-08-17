---
title: "Using Git/Obsidian Callouts in Quarto Markdown"
date: "2023-05-31"
url: "/2023/obsidian-quarto-callouts"
draft: false
tags:
- Quatro
- Obsidian
- Lua
- CSS
---

# About Callouts

*Disclaimer: Previous version of this post was originally published as a [public gist](https://gist.github.com/danieltomasz/87b1321e23c045309d2571f525f856cf)*

Callouts are a great way to highlight important details in your text by adding boxes with icons. Many flavours of markdown support them (but might use different syntax).

Quarto supports 5 callout types:

- `note`
- `warning`
- `important`
- `tip`
- `caution`.

Each type has a different color and icon. You can see examples in the [Quarto documentation](https://quarto.org/docs/authoring/callouts.html).

## The Problem

To use callouts in Quarto markdown (`qmd`) files, you need to use Pandoc's div syntax:

```md
::: {.callout-note}
This is a note callout 
:::
```

But Obsidian doesn't recognise this syntax. Instead, it uses:

``` markdown
> [!note] My note
>
> Note content
```

So there's no easy way to preview nice callouts in Obsidian before compiling to PDF.

Github also introduced callouts into its markdown flavour with the same syntax under name of [Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts)

# Lua Filters to the Rescue

Pandoc supports Lua filters that can modify the markdown before compilation.

I found a filter on the Obsidian forum and modified it to support Quarto callouts. You need to save the filter as `obsidian-callouts.lua` in your project's `filters` folder.

Then point to it in `_quarto.yml`:

``` yml
filters:
- filters/obsidian-callouts.lua
```

Content of the file `obsidian-callouts.lua` is in the following gist :

{{< gist danieltomasz 31d298aca2969adaf60d8841b68005e2 >}}

This makes Obsidian's callout syntax compile properly in Quarto.

# Tweaking Obsidian CSS

By default Obsidian only styles `note` and `warning` callouts. To match Quarto, add this CSS:

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

Now the callouts look the same in Obsidian and compiled PDFs!

Below is the Obsidian markdown that can be used to generate the basic 5 types of callouts that map nicely to Quarto types:

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

Obsidian support for callouts is much more [extensive](https://help.obsidian.md/Editing+and+formatting/Callouts).

## Caveat

This approach makes callouts render nicely in Obsidian, but may break other Quarto-supporting editors. Test thoroughly before relying on it.

Remember that in order for callouts to work you need to leave a empty line starting with `>` between title and content. If you want a line break in the rendered callout, you might need the same trick.

Since Quarto 1.3 callouts are represented as a [custom AST node](In Quarto 1.3, callouts are represented as a custom AST node.). (A version of Lua filter that generated native Pandoc Divs)[https://forum.obsidian.md/t/rendering-callouts-similarly-in-pandoc/40020/6] will not work with latest Quarto.

## More Obsidian + Quarto Tips

I use plugins to preview Quarto files in Obsidian:

- `obsidian-shellcommands` to run `quarto render`
- Custom button with `commander` to rerun compilation
- `qmd-as-md-obsidian` for basic `qmd` support

See the [plugin README](https://github.com/danieltomasz/qmd-as-md-obsidian) for more workflow advice.

Let me know if you have any other questions!
