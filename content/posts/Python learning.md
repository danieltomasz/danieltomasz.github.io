
---
title: Python learning
date: 2023-08-07
description:
draft: true
tags:
---

# Python learnings

## Fixtures

Question: How I can pass objects from one test to another in pytest?

Answer:  Use `pytest` fixtures. Define a fixture function that returns the object you want to share, and have your tests take that fixture as a parameter. The fixture will run once per test module and the same object will be passed into all tests using that fixture.

```python
import pytest

@pytest.fixture
def my_shared_object():
  return MyClass()

# test_file.py 

def test_1(my_shared_object):
  # use the object

def test_2(my_shared_object):
  # same instance of the object
```