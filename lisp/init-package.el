(use-package restart-emacs)

(use-package hungry-delete
  :bind (("C-c DEL" . hungry-delete-backward))
  :bind (("C-c d" . hungry-delete-forward)))

(use-package drag-stuff
  :bind (("<M-up>" . drag-stuff-up))
  ("<M-down>" . drag-stuff-down))

(provide 'init-package)
