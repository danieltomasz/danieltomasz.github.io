---
title: "Blogging with quatro"
author: "Daniel Borek"
aliases: 
- /science/
date: "2023-03-22"
date-modified: 2023-03-22
categories: [meta]
draft: false
---

This post is about

This is the first post in a Quarto blog. Welcome!


Since this post doesn't specify an explicit `image`, the first image in the post will be used in the listing page of posts.

Reference  to [post](posts/2022/03/post-no-code) for a post with code.

###  Setting up Comments

I am choosing Giscus.
- Install giscus

Hi I am putting a quick hacks for anyone who will have this problem

I put

```
\let\standardclearpage\clearpage
\let\clearpage\relax 
```

otherwise leaving it empty,  
then I put

```
\let\clearpage\standardclearpage
```

where my actual text starts, it give me no break/empty page between index and chapters  
I am sure that this can be done with pandoc template and conditional to ignore index

but this is not solving the problem,, only hiding it