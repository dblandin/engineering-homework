# Code Climate Engineering Homework

## Instructions

### Assessment

This outlines an engineering problem representative of what we have run across at Code Climate. Answers will be evaluated on the following criteria:

* Accuracy
* Code quality -- Design, readability, tests
* Performance

### Tips

Feel free to use an implementation language of your choice, however we strongly recommend taking advantage of an existing Ruby parser, rather than attempting to implement one from scratch:

* [Parser](https://github.com/whitequark/parser)
* [RubyParser](https://github.com/seattlerb/ruby_parser)
* [Ripper](http://ruby-doc.org/stdlib-2.0.0/libdoc/ripper/rdoc/Ripper.html)

Before you begin, ensure that you have a working Docker instance, and have read through [this blog post](http://blog.codeclimate.com/blog/2015/07/07/build-your-own-codeclimate-engine/) (it will help with setup as well). 

This repository provides a sample Dockerfile for you to use.

## Problem

The Code Climate CLI runs a series of Docker containers, known as Engines. The output of these engines is specified in the official [Code Climate Spec](https://github.com/codeclimate/spec/blob/master/SPEC.md). You will be implementing an Engine that measures the complexity of files. Carefully read the Spec before implementing the problems below.

1. Fork this repository and push your solution to your fork when you are finished.

1. Write a command-line program at `bin/complexity` that computes the McClimate Complexity of the methods within a set of Ruby source code files stored in a local Git source tree. The McClimate Complexity is a fictional metric to assess the complexity of a mathematical formula.

  	* Start at 1
  	* Add 1 for every use of the four main arithmetic operators (+, -, * and /)
  	* Add 1 for every literal number
  	
    For example, the McClimate Complexity of this example method `foo` is 5 (1 + 2 operators + 2 literals):

    ```ruby
    def foo
      x = 1 * 2 + y
    end
    ```

    When invoked, the engine should emit an issue for every method with a McClimate Complexity higher than 10. Here is an example issue:
    
    ```json
    { 
	    "type": "issue",
  	  "check_name": "complexity",
      "description": "'#foo' has a complexity of 11", 
      "categories": ["Complexity"], 
      "location": {
        "path": "file.rb", 
        "lines": {
          "begin": 13, 
          "end": 14
        }
      }, 
      "remediation_points": 500
    }
    ```

    Note that some of these fields are static within the confines of this exercise: `type`, `check_name`, `categories`, and `remediation_points`.
    
    Issues are printed to STDOUT and separated by a null byte. This is an example output for the program:
    
         $ ./bin/complexity path/to/git/repo
         { "type": "issue", "check_name": "complexity", "description": "'#foo' has a complexity of 11", "categories": ["Complexity"], "location": {"path": "file.rb", "lines": {"begin": 13, "end": 14}}, "remediation_points": 500}\0    
  	     
    _Note:_ The McClimate Complexity should be calculated for all methods defined in the file, including those in class and module definitions, however the class/module names can be discarded for now. (That is, a method `Foo#bar` should be reported, but can be reported as simply "`#bar` in `foo.rb`")
         
2. Package the program as a Code Climate Engine, following the guidelines in the **Packaging** section of the spec and using the example repository provided. Most importantly, the `path/to/git/repo` will be mounted as `/code` within the container. Verify that this works by creating a `.codeclimate.yml` in your directory and running `codeclimate analyze --dev`. Refer back to [this post](http://blog.codeclimate.com/blog/2015/07/07/build-your-own-codeclimate-engine/) for help packaging and running the Engine from the CLI.

  A sample `.codeclimate.yml` file that you can use is provided here:

  ```yaml
  engines:
    mcclimate:
      enabled: true
  ```

  As well as a docker build command (to be run within this repository):

  ```command
  docker build --rm -t mcclimate .
  ```

  When you're done, you should be able to run `codeclimate analyze --dev` and see the results of your new Engine.

3. Create a new program that can compare the analysis results for two different already-analyzed commits, using only the results of the complexity engine (_not the Git repo_). You can store those results in text files. It should display new and fixed issues. (If an issue is identical between revisions, it should not be printed.) For example:


  ```console
  git checkout commit_a
  codeclimate analyze -f json --dev > commit_a.json
  git checkout commit_b
  codeclimate analyze -f json --dev > commit_b.json

  ./bin/compare commit_a.json commit_b.json
  NEW: McClimate complexity of '#new_method' in file.rb exceeds 10.
  FIXED: McClimate complexity of '#fixme' in file.rb exceeds 10.
  ```

4. **Extra Credit:** We are interested in optimizing our Engines-based analysis. To do so, we are going to expose a directory `/cache` to each Engine, which is _persisted across multiple Engine runs_. (e.g. You can simulate this by adding a `-v /tmp/cache:/cache:rw` option to the `docker run` outlined [here](https://github.com/codeclimate/codeclimate/blob/f345a9a9afd9f69e6aeb2e9e93829f04be43892a/lib/cc/analyzer/engine.rb#L81-L97).) Modify the engine to leverage this new caching ability to be as efficient as possible, as the Engine is invoked for every Git commit the developer pushes.
