;;; use-package-eglot.el --- A use-package keyword for eglot LSP servers  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Aidan Hall

;; Author: Aidan Hall <aidan.hall202@gmail.com>
;; Keywords: languages, convenience, config
;; Package-Requires: ((eglot "1.17.30") (use-package "2.4.6"))
;; URL: https://gitlab.com/aidanhall/use-package-eglot
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
;; convenient way to set up an LSP server program to use with `eglot'
;; when one is not specified by default, or by a major mode package.
;;
;; Example usage:
;;
;;     (use-package swift-mode
;;       :eglot "sourcekit-lsp")
;;
;;     (use-package tablegen-mode
;;       :eglot '(tablegen-mode "tblgen-lsp-server"))
;;
;;     (use-package css-mode
;;       :eglot ("vscode-css-language-server" "--stdio"))
;;
;;     (use-package typst-ts-mode
;;       :eglot (lambda (_interactive _project)
;;                (unless (file-executable-p typst-ts-lsp-download-path)
;;                  (typst-ts-lsp-download-binary))
;;                (list typst-ts-lsp-download-path)))


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
       
       ((functionp arg)
        `(cons ',(use-package-as-mode name-symbol) ,arg))
       
       ((and (consp arg) (stringp (car arg)))
        `'(,(use-package-as-mode name-symbol) . ,arg))
       ((null arg)
        (use-package-error
         (concat label " wants a string, list of strings, function, or a (MAJOR-MODES . CONTACT) form.")))
       (t arg)))))


(defun use-package-handler/:eglot (name-symbol keyword arg rest state)
  "Generate handler code for the use-package `:eglot' keyword."
  (let ((body (use-package-process-keywords name-symbol rest state)))
    (use-package-concat
     body
     `((with-eval-after-load 'eglot
         (add-to-list 'eglot-server-programs ,arg))))))

(add-to-list 'use-package-keywords :eglot t)

(provide 'use-package-eglot)
;;; use-package-eglot.el ends here
