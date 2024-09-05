---
title: "Tracking Word Count Progress in Git"
description: "Count your progres with Typst project"
url: "/2024/count-progress-git"
date: "2024-09-05T1:00:00-07:00"
draft: false
tags: [git, typst,bash, productivity]
---

I created a simple script to count word changes in my git repository. I'm trying Typst now for writing an article in VSCode, and there's no good extension to quantify daily progress. This script looks at your commits, counts words added, deleted, and duplicated in  the files of  the extension by  your choice (by default .typ and .md files). It shows a daily breakdown of writing progress.

Got the idea from a [Gijs van Dam's blog post ](//www.gijsvandam.nl/post/measuring-your-writing-progress-with-a-git-word-count/) (who described logic behind  the word change calculation).  I adapted it by adding Typst and extending the way it display the output.  I add some additions like  handling the first commit: The script checks if it's dealing with the first commit in the repo, which doesn't have a parent to compare against and it stops.

It's been helpful for tracking my word count (and writing it was a nice excuse to not writing the text  I supposed to write). Below you can find the gist with the latest version. 

[https://gist.github.com/danieltomasz/e3be94d7f03ade2eb030edf63920e95a](https://gist.github.com/danieltomasz/e3be94d7f03ade2eb030edf63920e95a)