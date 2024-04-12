# SQL major mode using tree-sitter

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This package is compatible with and was tested against the tree-sitter grammar
for SQL found at [tree-sitter-sql](https://github.com/DerekStride/tree-sitter-sql).

**TODO**
It provides indentation, font-locking, imenu, and navigation support for SQL buffers.

![example](doc/example.png)

## Installing

Emacs 29.1 or above with tree-sitter support is required. 

Tree-sitter starter guide: https://git.savannah.gnu.org/cgit/emacs.git/tree/admin/notes/tree-sitter/starter-guide?h=emacs-29

### Install tree-sitter parser for SQL

Add the source to `treesit-language-source-alist`. 

```elisp
(add-to-list
 'treesit-language-source-alist
 '(sql "https://github.com/DerekStride/tree-sitter-sql"))
```

Then run `M-x treesit-install-language-grammar` and select `sql` to install.

### Install sql-ts-mode.el from source

- Clone this repository
- Add the following to your emacs config

```elisp
(require "[cloned nverno/sql-ts-mode]/sql-ts-mode.el")
```

### Troubleshooting

If you get the following warning:

```
⛔ Warning (treesit): Cannot activate tree-sitter, because tree-sitter
library is not compiled with Emacs [2 times]
```

Then you do not have tree-sitter support for your emacs installation.

If you get the following warnings:
```
⛔ Warning (treesit): Cannot activate tree-sitter, because language grammar for sql is unavailable (not-found): (libtree-sitter-sql libtree-sitter-sql.so) No such file or directory
```

then the sql grammar files are not properly installed on your system.
