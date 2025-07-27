;;; use-package-eglot.el --- A use-package keyword for eglot LSP servers  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Aidan Hall

;; Author: Aidan Hall <aidan.hall202@gmail.com>
;; Keywords: languages, convenience, config
;; Package-Requires: (eglot use-package)
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This file sets up the `:eglot' use-package keyword, that provides a
;; convenient way to set up an LSP server program to use when one is
;; not specified by default, or by a major mode package.
;;
;; Example usage:
;;
;;     (use-package mlir-mode
;;       :eglot "mlir-lsp-server")
;;
;;     (use-package typst-ts-mode
;;       :eglot typst-ts-lsp-download-path)
;;
;;     (use-package css-mode
;;       :eglot `((css-mode css-ts-mode)
;;                "vscode-css-language-server" "--stdio"))


;;; Code:

(require 'use-package)
(require 'eglot)

(defun use-package-normalize/:eglot (name-symbol keyword args)
  "Turn ARGS into a pair of the form (MAJOR-MODE . CONTACT).
For the form of MAJOR-MODE and CONTACT, see `eglot-server-programs'."
  (use-package-only-one (symbol-name keyword) args
    (lambda (label arg)
      (cond
       ((stringp arg)
        `'(,(use-package-as-mode name-symbol) ,arg))
       
       ((or (functionp arg) (symbolp arg))
        `(cons ',(use-package-as-mode name-symbol) ,arg))
       
       ((consp arg)
        (if (stringp (car arg))
            `'(,(use-package-as-mode name-symbol) . ,arg)
          (list 'quote arg)))
       (t
        (use-package-error
         (concat label " wants a string, list of strings, function, or a (MAJOR-MODES . CONTACT) form.")))))))


(defun use-package-handler/:eglot (name-symbol keyword arg rest state)
  (let ((body (use-package-process-keywords name-symbol rest state)))
    (use-package-concat
     body
     `((with-eval-after-load 'eglot
         (add-to-list 'eglot-server-programs ,arg))))))

(add-to-list 'use-package-keywords :eglot t)

(provide 'use-package-eglot)
;;; use-package-eglot.el ends here
