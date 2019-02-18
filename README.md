# dots

## Introduction

This repository contains my personal dotfiles. Most of it is geared towards a git-, Emacs-, and zsh-centric workflow. You'll also find some legacy files for e.g. bash that haven't been touched in ages.

This repository also contains a pretty useful script called `configctl`, which is used to manage all the files in this repository. It's very smart, fully automatic, and is pretty easy to understand (`head -25 configctl` will show a nice overview of the parameters, and you can get a nice help summary by executing `./configctl help`).

`configctl` knows how to:

* Link configurations into place
* Install tools in ~ from both git clones and tarballs
* Preinstall Emacs packages
* Migrate old configurations
* Precompile zsh scripts
* Check for common binaries that I expect to have available
* Perform other miscellaneous tasks

To put it another way, `configctl` knows how to bootstrap most of the environment I expect by itself, and it knows how to tell me what's missing for almost all of the rest.

`configctl` requires only POSIX, so it will run under almost any Unix under the sun.

## local-config

`configctl` has the capability to read in a local configuration file, `local-config`. With this file you can override the behavior of certain routines of `configctl`. `local-config` is written with one keyword per line. Here are the options:

| Option        | Type               | Description                                                                                                                                   |
| ------------- | -------------------| --------------------------------------------------------------------------------------------------------------------------------------------- |
| `no-ssh`      | Configuration time | Specifies that `configctl check` should not warn if it cannot find a general-purpose SSH key.                                                 |
| `headless`    | Configuration time | Specifies that `configctl check` should not warn if it cannot find programs that would only make sense to have under a graphical environment. |
| `no-nodejs`   | Configuration time | Specifies that `configctl check` should assume that Node.js is not available.                                                                 |
| `darwin`      | Configuration time | Specifies that `configctl check` is running on a Darwin (macOS) system. Linux is assumed otherwise.                                           |
| `set-inotify` | Runtime            | Specifies that `.profile` should set the maximum user inotify instances to 50,000 using `sudo`.                                               |

## License

Unless otherwise noted, the contents of this repository are licensed under [the WTFPL][1].

 [1]: https://github.com/strugee/dots/blob/master/COPYING
