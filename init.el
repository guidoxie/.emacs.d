(add-to-list 'load-path
        (expand-file-name (concat user-emacs-directory "lisp")))

(require 'init-startup)
(require 'init-ui)
(require 'init-tools)
(require 'init-lsp)

