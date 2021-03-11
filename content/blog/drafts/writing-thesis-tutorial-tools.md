
---
title: 'Writing master thesis tips about tools'
date: 2021-03-11
draft: true
featuredImg: ""
tags: 
  - python
  - markdown teaching
---


## Writing the content
### Markdown over Word
I wrote my master using LateX. Although there exist many templates for thesis in LateX if someone doesnt used LateX during their studies I am recomending Markdown. Markdown is a lightweight markup language for text files. Even this post is written in markdown

### Bibliography and references
- My prefered reference manager is Zotero
	- from Mendeley different features are now removed, and it is developed by evil corporation®, also your data are locked in
	- There exist other alternatives,like Paperpile, Citavi, Bookends
- Advantages of using reference manager
	- You can store your literature references and pdf or copy of webpages
	- you can sync them between devices, you have online copy of you library
	- It works, with Word, Google Docs, Markdown and latex, you could easily cite works stored in your library in your reference manager
- Zotero has many plugins, one of my favorites is Zotfile, which allows you to store your pdf  files in  any folder, for example Dropbox

## Setup Python

### Installing python environment
- Windows
- Linux 
- MacOS

### Python editor of choice


There exist many of possibilities
- **Jupyter Lab** - this is kind of IDE for Jupyter notebooks, allow you for writing comments as a markdown cells and code to execute in the same file.
	- I really recommend the  latest Jupyter 3, this the newest version, when you installed python via anaconda you can install 
		```
		conda uninstall jupyterlab
		conda install -c conda-forge jupyterlab=3

		```
	- there are many plugins, my favorite is [jupyterlab-variableInspector](https://github.com/lckr/jupyterlab-variableInspector) Is a plugin that allow you to see defined variables in your active kernel
	- to reload your custom functions you loaded from scrips you need to put this lines at the beginning of your script
		 ```py
		%load_ext autoreload
		%autoreload 2
		```
- **jupytex** is an package which  allows you to convert between py scripts and jupyter notebooks, you could even pair the files so they will be automatically synced. 
	- You could use `jupytext --to notebook notebook.py` to convert script to notebook (you need to substitute  name of your file)
	- for creating scripts from notebooks use `jupytext --to py:percent --opt  notebook.ipynb`

- **Spyder**
	- Spyder is simple IDE for numerical computation, it allows you to see the output of your executed code 
	- Install [**spyder-kernel**](https://pypi.org/project/spyder-terminal/) to have an access to terminal inside the app inside

- **Pycharm**
	- Paid app in their pro version, but access for student is free through Github student pack, Community Edition is free for all
	- Good integration of Jupyter notebooks inside the app (although only  in the pro version )
	- When I was trying it, it was quite slow loading all python packages when starting, mayb it changed

- [**VSC**](https://code.visualstudio.com/) my current choice. Many plugins, really nice and improving Python setup
	-	in comparison to **Spyder** this much more stable, Python plugin allow for preview of the environment when script is run in the interactive mode
	- Integrated support for Jupyter notebooks (although not full, for example I cannot reorder cells by simple moving them)
	- killer feature - [Visual Studio Live Share](https://code.visualstudio.com/blogs/2017/11/15/live-share) when you want to work on the same code in real time

## Github

### Command line github
### Desktop github
https://desktop.github.com/

## Writing code

### Write functions

Write function every time you plan to reuse the piece of code

### Use main in script

Is allows you to import you functions in other scripts without executing the code contined in the scipt. 

### Debuging 
 Debugging is really important part of writing code 
 
 ### Use PEP8 style for writng
 
 When you can use [PEP8](https://www.python.org/dev/peps/pep-0008/#imports) Style  Guide. PEP stands for Python Enhancement Proposals. 
 
 You could even watch a song about PEP8  made by Python discord community
 
 <iframe width="560" height="315" src=" https://www.youtube.com/watch?v=hgI0p1zf31k" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
