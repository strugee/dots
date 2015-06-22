# dots

## Introduction

This repository contains my personal dotfiles. Most of it is geared towards a git-, Emacs-, and zsh-centric workflow. You'll also find some legacy files for e.g. bash that haven't been touched in ages.

This repository also contains a useful script called `configctl`, which is used to manage all the files in this repository. It's semi-automatic and is pretty easy to understand (`head -25 configctl` will show a nice overview of the parameters, and you can get a nice help summary by executing `./configctl help`).

## local-config

`configctl` has the capability to read in a local configuration file, `local-config`. With this file you can override the behavior of certain routines of `configctl`. `local-config` is written with one keyword per line. Here are the options:

| Option     | Description                                                                                                                                   |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `no-ssh`   | Specifies that `configctl check` should not warn if it cannot find a general-purpose SSH key.                                                 |
| `headless` | Specifies that `configctl check` should not warn if it cannot find programs that would only make sense to have under a graphical environment. |

## License

Unless otherwise noted, the contents of this repository are licensed under [the WTFPL][1].

 [1]: https://github.com/strugee/dots/blob/master/COPYING
