(eval-when-compile
  (require 'use-package))

(major-mode-hydra-bind emacs-lisp-mode "Eval"
  ("ee" eval-last-sexp "sexp")
  ("eb" eval-buffer "buffer")
  ("ed" eval-defun "defun")
  ("er" eval-region "region"))


(provide 'th-elisp)
