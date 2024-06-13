---
title: "How to autorename files using Zotero"
description: "Autorenaming - another reason that Zotero is great"
date: "2024-06-13"
lastmod:
draft: false
summary: File renaming automation with Zotero
tags:
- Zotero
- Bibliography
---

After listening an episode of `PhD Life Coach` podcast (reccomeded to everyone relared to academia) on [How to be your own best personal assistant](https://thephdlifecoach.buzzsprout.com/1992545/15220518-2-39-how-to-be-your-own-best-personal-assistant) Iearned that some academic people still spent their time on renaming pdfs downloaded from internet. I want to share an important message to those people :) :  

1. If you deal if structured articles (web, pdf) please use Reference Mangers, even if you don't cite those articles that often; It will remove many of your headeaches and you can have nice organisation of your research materials
2. Even if you want to store PDFs inside specific projects a Reference Mangers can be really useful by automatic file renaming for you (you can move this files to another folder later). If you need to standardize the naming convention for all your PDF files or want to include specific metadata in the file names, Zotero or other reference mangers offers built-in functionalities and add-ons to achieve this efficiently.

Here a quick tips how to rename files using Zotero.

I am using [Zotero 7 Beta](https://www.zotero.org/support/beta_builds) (which offer nicer interface that [Zotero 6](https://www.zotero.org/download/)  and some additional features like epub or webpages annotation, and is really stable and I hope will soon released as stable version) so my description might be slightly different from what people using previous version may sees .

- In Zotero Go to Edit > Preferences (or Zotero > Preferences on a Mac).
- In the General tab, check the box •` Automatically rename locally added files`

The 'Rename linked files' will matter only the files added to Zotero items arent story with Zotero folder (where every bibliographic item has its own folder with the not so meaningful alphanumeric name ) but out outside of Zotero (when you move the file, you will broke the link )

if you click `Customize Filename Format…` you can customize the format,.

For example using filename template  
`{{ firstCreator suffix=" - " }}{{ year suffix=" - " }}{{ title truncate="100" }}` the resulting name will result in the filename similar to the one below:  
`Aljalal et al. - 2024 - Selecting EEG channels and features using multi-objective optimization for accurate MCI detection v.pdf`

On the official documentation page you can find the options you can use explained in more depth [file_renaming \[Zotero Documentation\]](https://www.zotero.org/support/file_renaming)

You easily rename in bulk the files that you already downloaded and store in Zotero if for some reason you prefer to change the pattern in the future.

  Zotero will add a great value to you ith its Browser Plugin Zotero Connector (which attomatical download and add pdf (if you have acces to it on publishers page) or snapshot of webpage to your local library ), and apperently this is not a comment knowledge, as prof. Inga Mewburn from [The Thesis Whisperer][thttps://thesiswhisperer.com/] blog and On the reg podcast recently admitted in one of the episosed that she learned about the connector after few years of using Zotero.

If you prefer to have linked files in one big folder, the Zotfile or other plugin that offer the same capabilities are something for you.

Even if you prefer have PDFs in the folders of your projects, you can always easily open folder conating the renamed files and move it to the project folder.
