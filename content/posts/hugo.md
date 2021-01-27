---
title: 'Hugo tricks'
date: 2021-01-27
draft: true
featuredImg: ""
tags: 
  - python
  - poetry
---

## How to  make Hugo render drafted content?
[Here](https://kodify.net/hugo/pages/generate-draft-content/) you could find source for this advice/

1. Add option to `config.toml`:
```
title = "Hugo example site"
baseurl = "https://www.example.com"
buildDrafts = true
```

2) Generate drafted files during the current Hugo build

```
hugo server --buildDrafts
```

or 
```
hugo server -D
```

To not generate draft content when building our static website, use one of the following command flags:
```
hugo --buildDrafts=false
hugo -D=false
hugo -D=F
```

