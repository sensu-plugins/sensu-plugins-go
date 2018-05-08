## Table of Contents

- [Naming Conventions](#naming-conventions)
- [Build Tools](#build-tools)
  - [Compiling](#compiling)
  - [Dependency Management](#dependency-management)
  - [Linting, Formating, etc](#linting-formating-etc)
- [Documentation](#documentation)
    - [Changelog](#changelog)
    - [Readme](#readme)
    - [Copyright And Licensing](#copyright-and-licensing)
    - [External Documentation](#external-documentation)
- [Configuring And Usage](#configuring-and-usage)
    - [Exit Codes](#exit-codes)

## Naming Conventions

- Binaries should not have an extension unless they are designed to work on Windows
- Dashes(`-`) and Underscores(`_`) should not be used in filenames or in the directory structure, Golang gets really unhappy. If you have to use one for the name of a binary then please use dashes.
- camelCase is the name of the game at Yieldbot when it comes to golang, please use this format.

## Build tools

### Compiling

`go build` is the tool used for building the binary. In the case of using `godep`, `godep go build` is the command executed. Please see the godep documentation for more information. This will be the preferred and currently, only supported way to handle vendoring at Yieldbot but you are free to use your own methods as long as they work for you

### Dependency Management

The standard way to mange them will be via Godep. This tool allows developers to easily pin and manage third party dependencies without having to fork them or copy them them into the repo manually.

For more details on managing dependencies using this tool check out the [project repo](https://github.com/tools/godep).

### Linting, Formating, etc

`gofmt` is enforced in the build pipeline and any errors will return the file that failed. You can correct them with `make format_correct` or `gofmt -w <file>`.

Linting and Vetting is not currently enforced but those tools are available and their usage is encouraged. If you would like to avoid having to remember to use these tools then you can add a pre-commit hook to your `.git/hooks` and that way it will get run before every commit. The below example will run `gofmt` and abort the commit if it fails.

```shell
#!/bin/sh

gofiles=$(git diff --cached --name-only --diff-filter=ACM | grep '.go$')
[ -z "$gofiles" ] && exit 0

unformatted=$(gofmt -l $gofiles)
[ -z "$unformatted" ] && exit 0

echo >&2 "Go files must be formatted with gofmt. Please run:"
for fn in $unformatted; do
  echo >&2 "  gofmt -w $PWD/$fn"
done

exit 1
```

## Documentation

There are many ways to document your code, Godoc is the preferred method for design docs. Usr docs should go into the README.

### CHANGELOG

You need it plain and simple, please use the format outlined in [Keep A Changelog](http://keepachangelog.com/) as this is the standard way. A complete example is detailed below. [Semver](http://semver.org/) is a good idea and this project adheres to it and the CHANGELOG and README should be considered authoritative.

### README

It goes without saying that packages should have a README and that is should contain any relevant data that the user may require. If any of the following applies to a package it should be noted:
- modifications to the build pipeline
- specific dependencies
- install or usage instructions

### Copyright and Licensing
The preferred license for all code associated with code that is to be released is the [MIT License](http://opensource.org/licenses/MIT).

### External Documentation

Godocs is the easiest method to generate docs but creating and building man and info pages is also supported via the Makefile. Please see the documentation of each of these for details on how to use them.

## Configuring and Usage

All golang binaries should adhere to the [12 Factor App](http://12factor.net/) where applicable. This is not currently enforced but is **strongly** encouraged. To assist in this please use the [Cobra](https://github.com/spf13/cobra) and [Viper](https://github.com/spf13/viper) tools as they will generate binary scaffolding that does conform to this standard. Concerning monitoring applications, The order of preference for configuring is as follows:

1. Environment Variables
1. Command line Flags
1. [Viper](https://github.com/spf13/viper) Configuration File (dropped via Chef)

### Exit Codes

All binaries are strongly encouraged to use these [error codes](https://github.com/yieldbot/sensuplugin/blob/master/sensuutil/common.go). You can use other ones but if possible please add them. As monitoring progresses there is functionality that will be able to do more fined-grained exclusions based upon error codes. To take full advantage of this it is encouraged that you use these.
