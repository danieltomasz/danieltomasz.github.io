---
title: 'Python setup with poetry and  vsc'
date: 2021-01-27
draft: true
featuredImg: ""
tags: 
  - python
  - poetry
---

Manging python distributions and installing on new installation is not easy.
Mangaging virtual environments through `pyenv`  and `poetry` solve this problem.
Still. pointing in `Visual Studio Code`  project to the right Python version is not really  straightforward.

## Pyenv

1. You could install poetry using `brew`

    ```bash
    brew install pyenv
    ```

  I prefer [Pyenv](https://github.com/pyenv/pyenv-installer) installed from github. The solution below is copied from github

  ```bash
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  ```

2. Define environment variable `PYENV_ROOT` to point to the path where pyenv repo is cloned and add `$PYENV_ROOT/bin` to your `$PATH` for access to the pyenv command-line utility.
   
  ```bash
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  ```

1. Add pyenv init to your shell to enable shims and autocompletion. Please make sure eval `"$(pyenv init -)"` is placed toward the end of the shell configuration file since it manipulates PATH during the initialization. Restart shell.
```
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
```
4. Install one of the listed Python version
```
pyenv install --list
```
5. Make specific python version local or global
```
pyenv local <python-version>
```
### Update:
To upgrade to a specific release of pyenv, check out the corresponding tag:

```
cd $(pyenv root)
git fetch
git tag
git checkout v0.1.0
```


## Poetry 

TBA
Download existing project with TOML from github.
Install poetry

## VSC code

Add the following to your project `settings.json`:

In my case (I use venv directly in the folder of the specific project )

<!--"python.venvPath": "~/PhD/Projects/rhythmical/.venv/"-->
<!--"python.pythonPath": "~/PhD/Projects/rhythmical/.venv/bin/python"-->


```
"python.venvPath": "~/path/to/folder/.venv/"
"python.pythonPath": "~/path/to/folder/.venv/bin/python"
```

## Use Black for code formating

-  editor integration
- version control integration
- use precommit

https://dev.to/notsag/python-code-formatting-using-black-2fe1