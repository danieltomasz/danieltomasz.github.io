---
title: "PDF tweaks and tips with Quarto"
description: "Some tips and tricks for writing thesis with Quarto"
date: "2023-08-04"
draft: false
lastmod: "2023-08-04"
tags:
- Quatro
- Latex
---

_Disclaimer: This is work in progress, I will be updating this post as I standardize and create a separate template/extension repository._

I wrote my master thesis in LaTeX, but given that markdown is a bit nicer to write, so I decided to switch with my PhD thesis to Markdown.
I was trying with Pandoc but last year I switched to Quarto, as it is more flexible, and it is easier to customize.

## Nicer fonts and better handling of figures

I am sharing with you a fragment of my `_quarto.yml` file, with some tweaks I am using to make my PDF output nicer.

```yaml
 format:
  pdf:
    link-citations: true  # <1>
    number-sections: false
    reference-section-title: "References"
    pdf-engine: xelatex
    include-in-header:
      text: |
        \usepackage{epigraph} 
        %%
        %% Code related to fonts and how the output looks
        %%
        \usepackage{mathpazo}   % <2>
        \usepackage[T1]{fontenc}
        \usepackage[sups,osf]{fbb} % osf (or tosf) for text, not math # <2>
        \usepackage[scaled=.95]{cabin} % sans serif # <2>
        \usepackage[varqu,varl]{inconsolata} % sans serif typewriter # <2>
        %%
        %% Code related to figures in document
        %%
        \usepackage{float}  % <3>
        \graphicspath{{figures}{chapters/figures}{../figures}{chapters}} # <4>
        \let\origfigure\figure
        \let\endorigfigure\endfigure
        \renewenvironment{figure}[1][2] {
            \expandafter\origfigure\expandafter[H]
        } {
            \endorigfigure
        }
```

I put number as comments, so you can better understand specific lines.

1. Some options for PDF output (more or less self-explanatory)>
2. The font use by default template are ugly format, this look similar but are nicer.
3. Forcing figures to be placed where they are in the text
4. Allowing to use figures from different folders, and allowing to use relative paths to figures.

<!--Those are setting I am using to render  a working preview of a chapter.
 The final version will be using a font provided by my university: -->

## Use profiles to compile either whole book or thesis or single chapter

Since quarto  1.2  profiles are introduced [^2] In my use case I have on profile  `_quarto-thesis.yml` which include all chapters and preambles, and another `_quarto.yml` which I can use just to compile the current markdown file; If I want to render whole thesis I just use `quarto render --profile thesis`; you could have as many as you want of those profiles (I was procrastinating  that way with different look and templates for my thesis :slight_smile: )

## Roman numbering for front matter and arabic for main matter

I am inserting roman numbering for front matter and arabic for main matter.

```yaml
 format:
  pdf:
    include-before-body:
        text: |
           \pagestyle{plain}
           \pagenumbering{roman}

```

In main tex I switch back to arabic numbering:

```tex
\pagenumbering{arabic}

```

## Problem with _index.md_ and inserted blank page

As you write complex project, you want might want to have separate files for each chapter.
When you are using `quarto` to render your project, you could put them inside `index.md` in your root folder:

```markdown
{{include "chapters/chapter1.qmd"}}
{{include "chapters/chapter2.qmd"}}

```

Using `include` filter will add the content of the files to the `index.md` file when compiling.
This is nice solution, but I have a problem when I want to  use `quarto preview` to update and monitor resulting pdf when I change something in source files.
Unfortunately, `quarto preview` does not update output `.pdf` file when files added with `include` change, so I needed to choose another solution.


Alternative solution is to add chapters into you `_quarto.yml` file:

```yaml
project:
  output-dir: _output
  execute-dir: file

book:
  title: Title of my  thesis or book
  author:
    name: Author Name
  chapters:
    - index.qmd
    - chapters/chapter1.md
    - chapters/chapter1.md
```


I want to all of my content of to live in the 'chapters' folder.
 Unfortunately currently in `quatro` users always  need to include `index.md` (it makes sense when generating `html` as output, but not always when generating `pdf`).

I can leave the `index.md` file empty, but then I will have an empty page between my table of content and first chapter.
I can include the first chapter into index.md but then we were hitting the same problem on smaller scale again.

### My solution

By default, latex is adding a page break after each chapter, and the `index.md` file is treated as a chapter, even if empty.
As a hack, I am  hiding the problem by relaxing `\clearpage` behaviour in latex.

I am leaving my `index.md` file almost empty, I'm just adding this latex code [^1]:

```tex
\let\standardclearpage\clearpage
\let\clearpage\relax 
```

Then within my first chapter when my content start, I am returning to standard behaviour of `\clearpage`:

```tex
\let\clearpage\standardclearpage
```

This way I am not adding any extra page between my table of content and first chapter, and I can use `quarto preview` to monitor my changes.
In future the `quatro` behaviour might change regarding inclusion of `index.md``, you can follow discussion here:

## Useful materials

I just saw this post published on the blog of Cameron Patrick, it contains more useful information about writing thesis with `quarto`: https://cameronpatrick.com/post/2023/07/quarto-thesis-formatting/.

I am personally using modified `quarto-thesis` template for my thesis, you can find it here: https://github.com/nmfs-opensci/quarto-thesis
If you don't use quarto,  but you want to play with it, you can modify it online on the Posit virtual `Rstudio` instance https://rstudio.cloud/content/4383755 (free account required)

## References

[^1]: https://tex.stackexchange.com/a/176109
[^2]: [Quarto - Project Profiles](https://quarto.org/docs/projects/profiles.html)