---
title: pankyll-theme-rankle-example/README.md
author: Christian Külker
version: 0.1.8
date: 2023-03-16

---

# Abstract

This document briefly describes the purpose and contents of the
`pankyll-theme-rankle-example` repository. The goal of this repository is to
show the configuration and usage of the theme [Rankle] by providing a working
example with a directory tree that can be used as a base for building a new
site.

![Github license](https://img.shields.io/github/license/ckuelker/pankyll-theme-rankle-example.svg)
![Github issues](https://img.shields.io/github/issues/ckuelker/pankyll-theme-rankle-example.svg?style=popout-square)
![Github code size in bytes](https://img.shields.io/github/languages/code-size/ckuelker/pankyll-theme-rankle-example.svg)
![Git repo size](https://img.shields.io/github/repo-size/ckuelker/pankyll-theme-rankle-example.svg)
![Last commit](https://img.shields.io/github/last-commit/ckuelker/pankyll-theme-rankle-example.svg)

## History

| Version | Date       | Notes                                                |
| ------- | ---------- | ---------------------------------------------------- |
| 0.1.8   | 2023-03-16 | pankyll-pandoc 0.1.3, pankyll-documentation 0.2.1,   |
|         |            | pankyll-theme-rankle 0.1.8, Improve writing          |
| 0.1.7   | 2022-05-26 | pankyll-documentation 0.2.0, Improve info tgt,       |
|         |            | +update tgt, +submoduleclean dep g.yaml, shell->bash |
| 0.1.6   | 2022-05-19 | Makefile, bump copyright cfg.yaml, shell->bash       |
| 0.1.5   | 2022-05-09 | Improve Makefile, pankyll-documentation 0.1.8        |
| 0.1.4   | 2021-05-18 | pankyll-documentation 0.1.7, update cfg.yaml,        |
|         |            | top 10 feature, improve Makefile                     |
| 0.1.3   | 2021-05-15 | pankyll-documentation 0.1.6                          |
| 0.1.2   | 2020-10-21 | Theme version 0.1.3, Makefile                        |
| 0.1.1   | 2020-05-13 | Makefile, Readme, Features                           |
| 0.1.0   | 2020-03-29 | Initial release                                      |

# Introduction

More than a 1000 words, a life example can show how things are done the right
way. This [Pankyll] theme [rankle] example is a pre-configured [Pankyll] theme
with a little content to see how easy it is to set up a [Pankyll] site with a
[rankle] theme.

# Prerequisites

**TLTR:**

Requires [Pankyll] and on [Debian] install the following:

As root

```bash
aptitude install pandoc fonts-noto-cjk fonts-wqy-microhei make
```

As user

```bash
export URL=https://github.com/ckuelker/pankyll-theme-rankle-example.git
git clone --recursive $URL
```

## Pankyll

We assume that [Pankyll] is installed and that the script `pankyll` is in your
`PATH`. See the Pankyll `README.md` file for more information.

## Pandoc

[Pandoc] is expected to be installed. While it is possible to run `pankyll`
with `pandoc` 1.x.x, it will not give good results. [Pankyll] has been tested
with versions 2.2.1, 2.10.1 and should give good results. Unfortunately Pandoc
2.18 is not supported at the moment.

**Installation for Debian:**

```bash
aptitude install pandoc
```

## Fonts

For creating PDF files from Markdown, the following fonts seem to give the best
results. For [Pankyll] 0.1.0 the names are hard-coded, this may change in
future releases.


* Noto Sans CJK JP
* Noto Sans Mono CJK JP Bold
* WenQuanYi Micro Hei Mono

**Installation for Debian:**

```bash
aptitude install fonts-noto-cjk fonts-wqy-microhei
```

## Make

An optional Makefile is used to control easy build. If you do not want to use
it, just run the `pankyll` command in your project directory. If you want to
use it, see the usage section.

**Installation for Debian:**

```bash
aptitude install make
```

# Installation

Clone the example repository and its sub-modules

```bash
export URL=https://github.com/ckuelker/pankyll-theme-rankle-example.git
git clone --recursive $URL
```

# Usage

Update, build and see the site:

```bash
cd pankyll-theme-rankle-example
make submodule-update
make submoduleclean
make submodule-pull
make realclean
make build
make server
```

Or all at once:

```bash
make all
```

Open a browser and access the URL [http://localhost:8001](http://localhost:8001)

# Author

    Christian Külker <c@c8i.org>

# License And Copyright

    Copyright (C) 2020 - 2023 by Christian Kuelker, see LICENSE file.

[Debian]: https://www.debian.org/
[Newspaper]: https://github.com/ckuelker/pankyll-theme-newspaper/
[Pandoc]: https://pandoc.org/
[Pankyll]: https://www.pankyll.org/
[Rankle]: https://github.com/ckuelker/pankyll-theme-rankle
[README.md]: https://github.com/ckuelker/pankyll
[Simplicissimus]: https://github.com/ckuelker/pankyll-theme-simplicissimus
