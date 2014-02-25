A little Scheme
===============

This repository contains executable examples of the behaviour of a simple Scheme interpreter, adapted from [The Little Schemer](http://www.ccs.neu.edu/home/matthias/BTLS/).

Each chapter’s examples are in a commit with an appropriate tag: `chapter-one`, `chapter-two`, `chapter-three` and so on. To begin implementing the functionality for a particular chapter:

```
$ bundle install
$ git checkout chapter-two
$ bundle exec rspec
```

The examples expect to be able to instantiate a class called `LittleScheme::Parser` and call its `parse` method to get the abstract syntax tree (AST) of a program, and then to be able to instantiate a class called `LittleScheme::Evaluator` and call its `evaluate` method to evaluate that AST. If you run the examples, the failures should guide you.
