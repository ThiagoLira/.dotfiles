(eval-when-compile
  (require 'use-package))

(major-mode-hydra-bind emacs-lisp-mode "Eval"
  ("e" eval-last-sexp "sexp")
  ("b" eval-buffer "buffer")
  ("d" eval-defun "defun")
  ("r" eval-region "region"))


(provide 'th-elisp)
