# `(use-package :eglot)`
This is a fork of https://gitlab.com/aidanhall/use-package-eglot

Registering an LSP server with eglot typically requires the following modest boilerplate:

```lisp
(use-package swift-mode
  :ensure t
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(swift-mode "sourcekit-lsp"))))
```

This package adds the `:eglot` keyword to `use-package`.
In most cases, using it is as simple as this:

```lisp
(use-package swift-mode
  :ensure t
  :eglot "sourcekit-lsp")
```

It handles a couple of different forms of arguments,
based on the different forms entries in `eglot-server-programs` may take.
Refer to the commentary section in [the file itself](use-package-eglot.el) for example usage.
