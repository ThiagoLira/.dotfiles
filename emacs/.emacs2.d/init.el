(setq user-emacs-directory "~/.emacs2.d/")

(setq gc-cons-threshold (* 800 1024))

(defconst emacs-start-time (current-time))

(unless noninteractive
  (message "Loading %s..." load-file-name))

(setenv "INSIDE_EMACS" "true")

;; Make sure package.el doesn't get a chance to load anything.
(setq package-enable-at-startup nil)


;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)


;; straight.el

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package
(straight-use-package 'use-package)

(eval-when-compile
  (require 'use-package))

;; Install some basic packages

(straight-use-package 'dash)
(straight-use-package 'dash-functional)
(straight-use-package 'f)
(straight-use-package 's)
(straight-use-package 'noflet)
(straight-use-package 'memoize)
(straight-use-package 'general)
(straight-use-package 'el-patch)
(straight-use-package 'which-key)




(defconst paths-config-directory
  (concat user-emacs-directory "config"))

(defconst paths-lisp-directory
  (concat user-emacs-directory "lisp"))



(require 'f)
(require 'seq)

(defun init-load-paths (&optional interactive-p)
  (interactive "p")
  (let* ((before load-path)
         (main-dirs
          (list paths-lisp-directory
                paths-config-directory
                ))
         (subdirs
          (f-directories paths-lisp-directory))
         (updated-load-path
          (seq-filter #'file-directory-p (seq-uniq (append main-dirs subdirs load-path)))))

    (setq load-path updated-load-path)
    (when interactive-p
      (if-let (added (seq-difference load-path before))
          (message "Load path updated. Added: %S" added)
        (message "No change to load-path")))))



(init-load-paths)

;;Evil
(use-package th-evil)
;;Hydras
(use-package th-hydras)
;;Languages
(use-package th-elisp)
