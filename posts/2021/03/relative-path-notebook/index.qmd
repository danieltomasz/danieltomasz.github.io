---
title: "How to get relative path of script or notebook in Python with Pathlib library"
author: "Daniel Borek"
date: 2021-03-04
date-modified: 2023-03-22
categories: [Python, Pathlib, howto]
draft: false
---

_Problem statement_:  You want to get an absolute path of your project where a file/notebook is located and join it with a string pointing to a folder.

Solution:

This function will give you an absolute path in relation to a current python script or notebook.

```python
from pathlib import Path

def get_project_root() -> Path:
    try:
        # This will give you a Path object pointing to the parent of the folder where the script is located.
        # If your script is `/root/scripts/script.py`, the result will be an absolute path '/root'.
        return Path(__file__).parent.parent
    except NameError as error:
        # This will give you  root folder of the project if this runned through jupyter notebook
        return Path().joinpath().absolute().parents[0]
    except Exception as exception:
        print(exception)
```

When you will work with `Path` paths don't add trailing slashes when joining paths. The code below:
```python
root= get_project_root()
path_to_file = Path.joinpath(root, '/data/data.feather')
```
will result in `path_to_file = /data/final.feather`. 

To obtain `path_to_file = /root/data/final.feather` you shouldn't use the slash at the begining:

```python
root= get_project_root()
path_to_file = Path.joinpath(root, 'data/data.feather')
```

