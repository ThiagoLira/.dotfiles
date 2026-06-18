;;; init.el --- bootstrap for a literate config -*- lexical-binding: t -*-

;; This is the only hand-written elisp file.  The real configuration
;; lives in config.org -- open it, read it, it explains everything.
;;
;; What happens here: if config.org is newer than its tangled output
;; (config.el), re-tangle it.  Then load the plain elisp.  Org is only
;; loaded when tangling is needed, so normal startups never pay for it.

(let* ((org-file (locate-user-emacs-file "config.org"))
       (el-file  (locate-user-emacs-file "config.el"))
       (first-run (not (file-exists-p el-file))))
  (when (file-newer-than-file-p org-file el-file)
    (message "config.org changed -- tangling...")
    (require 'ob-tangle)
    (org-babel-tangle-file org-file))
  (load el-file nil 'nomessage)
  ;; On the very first launch, the book itself is the welcome screen.
  (when first-run
    (setq initial-buffer-choice org-file)))
