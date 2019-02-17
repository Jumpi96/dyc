# DYC - Delete your code☠️

[![Build Status](https://travis-ci.com/Jumpi96/dyc.svg?branch=master)](https://travis-ci.com/Jumpi96/dyc)
[![codecov](https://codecov.io/gh/Jumpi96/dyc/branch/master/graph/badge.svg)](https://codecov.io/gh/Jumpi96/dyc)

A development tool that receives a file with the usage of functions in a project (potentially produced by a APM solution like the ones from DataDog or Stackify) and the code of the project itself. It process the information and generates reports based on it.

These project is part of a note I am writing and my first project into FP in general and Elixir in particular. It is a PoC more than an useful tool, but be free to use it.

## Use

You can use the tool using the binary `dyc`.
```
./dyc /path/to/code /path/to/file.csv
```

The solution is waiting for (currently) a Python project folder and a .csv file with the following format:
```
function,file,line,count
the_function(config_name=None),.the_path/the_file.py,0,100
```
