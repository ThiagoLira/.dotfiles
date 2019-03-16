;; (setq user-emacs-directory "~/.emacs2.d/")

(setq gc-cons-threshold (* 800 1024))

(unless noninteractive
  (message "Loading %s..." load-file-name))

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))


;; better defaults
(setq
 ad-redefinition-action 'accept                   ; Silence warnings for redefinition
 cursor-in-non-selected-windows t                 ; Hide the cursor in inactive windows
 display-time-default-load-average nil            ; Don't display load average
 fill-column 80                                   ; Set width for automatic line breaks
 help-window-select t                             ; Focus new help windows when opened
 inhibit-startup-screen t                         ; Disable start-up screen
 initial-scratch-message nil
 initial-major-mode 'emacs-lisp-mode              ; start scratch buffer on lisp mode
 kill-ring-max 128                                ; Maximum length of kill ring
 load-prefer-newer t                              ; Prefers the newest version of a file
 mark-ring-max 128                                ; Maximum length of mark ring
 scroll-conservatively most-positive-fixnum       ; Always scroll by one line
 select-enable-clipboard t                        ; Merge system's and Emacs' clipboard
 tab-width 4                                      ; Set width for tabs
 use-package-always-ensure t                      ; Avoid the :ensure keyword for each package
 user-full-name "Thiago Lira"                     ; Set the full name of the current user
 user-mail-address "thlira15@gmail.com"           ; Set the email address of the current user
 vc-follow-symlinks t                             ; Always follow the symlinks
 find-file-visit-truename t
 view-read-only t
 display-line-numbers-type 'relative
 display-line-numbers-width-start t)

(column-number-mode 1)                            ; Show the column number
(display-time-mode 1)                             ; Enable time in the mode-line
(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(global-hl-line-mode)                             ; Hightlight current line
(set-default-coding-systems 'utf-8)               ; Default to utf-8 encoding
(show-paren-mode 1)                               ; Show the parent




;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)


(defconst *is-a-mac* (eq system-type 'darwin))

(if *is-a-mac* (defvar fish-location  "/usr/local/bin/fish")
               (defvar fish-location "usr/bin/fish")) 


(if *is-a-mac* (defvar sbcl-location  "/usr/local/bin/sbcl") nil) 



;; bootstrap use-package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

(package-initialize)
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))

;; Install some basic packages

(use-package dash
  :ensure t)
(use-package dash-functional
  :ensure t)
(use-package f
  :ensure t)
(use-package s
  :ensure t)
(use-package noflet
  :ensure t)
(use-package memoize
  :ensure t)
(use-package el-patch
  :ensure t)
(use-package ivy
  :ensure t)
(use-package counsel
  :ensure t)
(use-package swiper
  :ensure t)
(use-package general
  :ensure t)
(use-package which-key
  :ensure t
  :defer 10
  :config
  (which-key-mode 1))
(use-package hydra
  :ensure t)
(use-package ace-window
  :ensure t)
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  )
(use-package monitor
  :ensure t)


;; projectile

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  )

;; THEME AND GUI


(use-package all-the-icons
  :ensure t)

(use-package doom-themes
  :ensure t)

(use-package doom-modeline
      :ensure t
      :hook (after-init . doom-modeline-mode)
      :config
      ;; How tall the mode-line should be (only respected in GUI Emacs).
      (setq doom-modeline-height 25)
      ;; How wide the mode-line bar should be (only respected in GUI Emacs).
      (setq doom-modeline-bar-width 3))


(add-hook 'after-init-hook (lambda () (load-theme 'doom-one t)))

;; EVIL MODE


(declare-function evil-delay "evil-common")
(declare-function evil-set-initial-state "evil-core")



(use-package evil
  :ensure t
  :demand t
  :functions (evil-mode evil-delay evil-delete-backward-char-and-join)
  :defines (evil-want-Y-yank-to-eol)
  :preface
  (progn
    (autoload 'evil-visual-update-x-selection "evil-states")
    (general-setq evil-want-keybinding nil)

    (defun config-evil-flyspell-on ()
      "Enable flyspell."
      (interactive)
      (turn-on-flyspell))

    (defun config-evil-flyspell-off ()
      "Disable flyspell."
      (interactive)
      (turn-off-flyspell)))
  :config
  (progn
    (evil-mode +1)
    (setq evil-mode-line-format nil)
    (setq-default evil-shift-width 2)
    (setq-default evil-symbol-word-search t)

    (setq evil-want-visual-char-semi-exclusive t)
    (setq evil-want-Y-yank-to-eol t)

    ;; Prevent visual state from updating the clipboard.

    (advice-add #'evil-visual-update-x-selection :override #'ignore)

    ;; Configure cursors.

    (setq evil-motion-state-cursor '("plum3" box))
    (setq evil-visual-state-cursor '("gray" hbar))
    (setq evil-normal-state-cursor '("IndianRed" box))
    (setq evil-insert-state-cursor '("chartreuse3" bar))
    (setq evil-emacs-state-cursor  '("SkyBlue2" (box . t)))

    ;; Motion keys for help buffers.

    (evil-define-key 'motion help-mode-map
      (kbd "<escape>") #'quit-window
      (kbd "^") #'help-go-back
      (kbd "gh") #'help-follow-symbol)

    ;; Initial states and keymaps for builtin Emacs packages.

    (evil-set-initial-state 'tabulated-list-mode 'motion)

    (evil-set-initial-state 'flycheck-error-list-mode 'motion)

    (evil-set-initial-state 'helpful-mode 'motion)

    (evil-set-initial-state 'grep-mode 'normal)

    (evil-set-initial-state 'occur-mode 'normal)
    (with-eval-after-load 'replace
      (evil-add-hjkl-bindings occur-mode-map))

    (evil-set-initial-state 'tar-mode 'emacs)
    (with-eval-after-load 'tar-mode
      (evil-add-hjkl-bindings tar-mode-map))

    (evil-set-initial-state 'profiler-report-mode 'motion)
    (with-eval-after-load 'profiler
      (evil-define-key 'motion profiler-report-mode-map
        "K" 'profiler-report-describe-entry
        "B" 'profiler-report-render-reversed-calltree))

    (with-eval-after-load 'compile
      ;; h (help) binding interferes with evil navigation.
      (evil-define-key 'motion compilation-mode-map (kbd "h") #'evil-backward-char))

    (evil-set-initial-state 'archive-mode 'emacs)
    (with-eval-after-load 'arc-mode
      (evil-define-key 'motion archive-mode-map
        (kbd "q") 'kill-this-buffer
        (kbd "RET") 'archive-extract
        (kbd "o") 'archive-extract-other-window
        (kbd "m") 'archive-mark
        (kbd "x") 'archive-expunge
        (kbd "U") 'archive-unmark-all-files
        (kbd "j") 'archive-next-line
        (kbd "k") 'archive-previous-line))

   ;; Window Movement
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

    (evil-set-initial-state 'wdired-mode 'normal)

    (evil-set-initial-state 'ert-simple-view-mode 'motion)

    (evil-set-initial-state 'diff-mode 'motion)

    (evil-set-initial-state 'haskell-debug-mode 'motion)

    (evil-set-initial-state 'ibuffer-mode 'motion)
    (evil-set-initial-state 'eshell-mode 'insert)

    (evil-set-initial-state 'mu4e-main-mode 'emacs)
    (evil-set-initial-state 'mu4e-headers-mode 'emacs)
    (evil-set-initial-state 'mu4e-view-mode 'motion)

    (evil-set-initial-state 'nix-repl-mode 'insert)

    (evil-set-initial-state 'prodigy-mode 'motion)

    (evil-set-initial-state 'anaconda-mode-view-mode 'motion)

    (evil-set-initial-state 'racer-help-mode 'motion)

    (evil-set-initial-state 'indium-inspector-mode 'motion)
    (evil-set-initial-state 'indium-repl-mode 'insert)

    (evil-set-initial-state 'org-agenda-mode 'motion)

    ;; Add ex commands for controlling spellcheck.

    (evil-ex-define-cmd "nospell" #'config-evil-flyspell-off)
    (evil-ex-define-cmd "spell" #'config-evil-flyspell-on)))



(use-package evil-surround
  :ensure t
  :commands (global-evil-surround-mode)
  :general
  (:states 'visual :keymaps 'evil-surround-mode-map
   "s" #'evil-surround-region
   "S" #'evil-substitute)
  :preface
  (defun config-evil--init-evil-surround-pairs ()
    (make-local-variable 'evil-surround-pairs-alist)
    (push '(?\` . ("`" . "'")) evil-surround-pairs-alist))
  :hook
  (emacs-lisp-mode-hook . config-evil--init-evil-surround-pairs)
  :init
  (setq-default evil-surround-pairs-alist
                '((?\( . ("(" . ")"))
                  (?\[ . ("[" . "]"))
                  (?\{ . ("{" . "}"))

                  (?\) . ("(" . ")"))
                  (?\] . ("[" . "]"))
                  (?\} . ("{" . "}"))

                  (?# . ("#{" . "}"))
                  (?b . ("(" . ")"))
                  (?B . ("{" . "}"))
                  (?> . ("<" . ">"))
                  (?t . evil-surround-read-tag)
                  (?< . evil-surround-read-tag)
                  (?f . evil-surround-function)))
  :init
  (with-eval-after-load 'evil
    (global-evil-surround-mode +1)))

(use-package evil-iedit-state
  :ensure t
  :commands (evil-iedit-state/iedit-mode)
  :config
  (general-setq iedit-current-symbol-default t
                iedit-only-at-symbol-boundaries t
                iedit-toggle-key-default nil))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-matchit
  :ensure t
  :init
  (with-eval-after-load 'evil
    (global-evil-matchit-mode +1)))

(use-package evil-numbers
  :after evil-common
  :ensure t
  :general (:states 'normal
            "+" #'evil-numbers/inc-at-pt
            "-" #'evil-numbers/dec-at-pt))


(use-package evil-nerd-commenter
  :after evil-common
  :ensure t
  :general (:states
            'normal
            ";" #'evilnc-comment-operator
            ;; Double all the commenting functions so that the inverse
            ;; operations can be called without setting a flag
            "gc" #'evilnc-comment-operator))

(use-package major-mode-hydra
  :ensure t
  :config
  (with-eval-after-load 'evil
    (evil-global-set-key 'motion (kbd ",") #'major-mode-hydra)
    (evil-global-set-key 'normal (kbd ",") #'major-mode-hydra)))



(defun er-switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

; (defun buffer-list ()
; (interactive)
  ; (switch-to-buffer (nil (current-buffer) 1 ))
  ; )


(defun split-and-move-down ()
  (interactive)
  (split-window-below) 
  (windmove-down)) 
(defun split-and-move-right ()
  (interactive)
  (split-window-right) 
  (windmove-right)) 

(general-define-key
 :states '(normal visual insert emacs)
 :prefix "SPC"
 :non-normal-prefix "C-SPC"

 ;; simple command
    "'"   '(iterm-focus :which-key "iterm")
    "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
    "/"   'counsel-ag
    "TAB" '(er-switch-to-previous-buffer :which-key "prev buffer")
    "SPC" 'counsel-M-x
    ";" 'shell-pop

 ;; Window operations 
  "w"   '(:ignore t :which-key "window")
  "w|" 'split-and-move-right 

  "w-" 'split-and-move-down
  "wd" 'delete-window
  "wx" 'delete-frame
 ;; Buffer operations
    "b"   '(:ignore t :which-key "buffer")
    "bb"  'ibuffer
    "bd"  'kill-this-buffer
    "b]"  'next-buffer
    "b["  'previous-buffer
    "bq"  'kill-buffer-and-window
    "bR"  'rename-file-and-buffer
    "br"  'revert-buffer

   ;; quit
   "qq" 'kill-emacs

    ;; emacs help
    "hV" 'describe-variable
    "hF" 'describe-function

    ;; find files
    "ff"  'counsel-find-file  ; find file using ivy
    "fr"  'counsel-recentf    ; find recently edited files
    "pf"  'counsel-git        ; find file in git project
    "ft"  'treemacs ;;treemacs toogle

	;; Applications
	"a" '(:ignore t :which-key "Applications")
	"ar" 'ranger
	"ad" 'dired
	"t"  'term
	"<f2>" 'hydra-zoom/body)



(defhydra hydra-zoom (:color green)
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))



;; TREEMACS

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python") 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))))



(use-package treemacs-evil
  :ensure t
  :after treemacs evil)



;; COMPLETION


(use-package company
  :ensure t
  :hook (after-init . global-company-mode))



;; ERROR CHECKING


(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode))



;; ORG

(use-package org
  :pin org)

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme  '(textobjects insert navigation additional shift todo heading))))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))



(major-mode-hydra-bind org-mode "Org"

  ("," org-ctrl-c-ctrl-c "magic")
)

;; ELISP


(use-package elisp-format
  :ensure t)


(major-mode-hydra-bind emacs-lisp-mode "Eval"

  ("ee" eval-last-sexp "sexp")
  ("eb" eval-buffer "buffer")
  ("ed" eval-defun "defun")
  ("er" eval-region "region")
  ("hv" find-variable-at-point "find var")
  ("hf" find-function-at-point "find fun")
)

;; CLOJURE

(use-package cider
  :ensure t
  :mode ("\\.clj\\'" . clojure-mode)
  )


(defun clojure/fancify-symbols (mode)
  "Pretty symbols for Clojure's anonymous functions and sets,
   like (λ [a] (+ a 5)), ƒ(+ % 5), and ∈{2 4 6}."
  (font-lock-add-keywords mode
    `(("(\\(fn\\)[[[:space:]]"
       (0 (progn (compose-region (match-beginning 1)
                                 (match-end 1) "λ")
                 nil)))
      ("(\\(partial\\)[[[:space:]]"
       (0 (progn (compose-region (match-beginning 1)
                                 (match-end 1) "Ƥ")
                 nil)))
      ("(\\(comp\\)[[[:space:]]"
       (0 (progn (compose-region (match-beginning 1)
                                 (match-end 1) "∘")
                 nil)))
      ("\\(#\\)("
       (0 (progn (compose-region (match-beginning 1)
                                 (match-end 1) "ƒ")
                 nil)))
      ("\\(#\\){"
       (0 (progn (compose-region (match-beginning 1)
                                 (match-end 1) "∈")
                 nil))))))



;; Change to nil to disable FANCYFICATION of symbols
(setq clojure-enable-fancify-symbols t)

(when clojure-enable-fancify-symbols
  (clojure/fancify-symbols 'cider-repl-mode)
  (clojure/fancify-symbols 'cider-clojure-interaction-mode))


(use-package clojure-mode
  :ensure t
  :config
  (when clojure-enable-fancify-symbols
	(dolist (m '(clojure-mode clojurescript-mode clojurec-mode clojurex-mode))
	  (clojure/fancify-symbols m))))


(clojure/fancify-symbols 'clojure-mode)


(defun cider-eval-in-repl-no-focus (form)
  "Insert FORM in the REPL buffer and eval it."
  (while (string-match "\\`[ \t\n\r]+\\|[ \t\n\r]+\\'" form)
    (setq form (replace-match "" t t form)))
  (with-current-buffer (cider-current-connection)
    (let ((pt-max (point-max)))
      (goto-char pt-max)
      (insert form)
      (indent-region pt-max (point))
      (cider-repl-return))))

(defun cider-send-last-sexp-to-repl ()
  "Send last sexp to REPL and evaluate it without changing
the focus."
  (interactive)
  (cider-eval-in-repl-no-focus (cider-last-sexp)))

(defun cider-send-last-sexp-to-repl-focus ()
  "Send last sexp to REPL and evaluate it and switch to the REPL in
`insert state'."
  (interactive)
  (cider-insert-last-sexp-in-repl t)
  (evil-insert-state))

(defun cider-send-region-to-repl (start end)
  "Send region to REPL and evaluate it without changing
the focus."
  (interactive "r")
  (cider-eval-in-repl-no-focus
   (buffer-substring-no-properties start end)))

(defun cider-send-region-to-repl-focus (start end)
  "Send region to REPL and evaluate it and switch to the REPL in
`insert state'."
  (interactive "r")
  (cider-insert-in-repl
   (buffer-substring-no-properties start end) t)
  (evil-insert-state))

(defun cider-send-function-to-repl ()
  "Send current function to REPL and evaluate it without changing
the focus."
  (interactive)
  (/cider-eval-in-repl-no-focus (cider-defun-at-point)))

(defun cider-send-function-to-repl-focus ()
  "Send current function to REPL and evaluate it and switch to the REPL in
`insert state'."
  (interactive)
  (cider-insert-defun-in-repl t)
  (evil-insert-state))

(defun cider-send-ns-form-to-repl ()
  "Send buffer's ns form to REPL and evaluate it without changing
the focus."
  (interactive)
  (cider-eval-in-repl-no-focus (cider-ns-form)))

(defun cider-send-ns-form-to-repl-focus ()
  "Send ns form to REPL and evaluate it and switch to the REPL in
`insert state'."
  (interactive)
  (cider-insert-ns-form-in-repl t)
  (evil-insert-state))

(defun cider-send-buffer-in-repl-and-focus ()
  "Send the current buffer in the REPL and switch to the REPL in
`insert state'."
  (interactive)
  (cider-load-buffer)
  (cider-switch-to-repl-buffer)
  (evil-insert-state))

(major-mode-hydra-bind clojure-mode "cider"

  ("'" cider-jack-in "jack-in")
  ("sb" cider-load-buffer)
  ("sB" cider-send-buffer-in-repl-and-focus)
  ("sC" cider-find-and-clear-repl-output)
  ("se" cider-send-last-sexp-to-repl)
  ("sE" cider-send-last-sexp-to-repl-focus)
  ("sf" cider-send-function-to-repl)
  ("sF" cider-send-function-to-repl-focus)
  ("sn" cider-send-ns-form-to-repl)
  ("sN" cider-send-ns-form-to-repl-focus)
  ("so" cider-repl-switch-to-other)
  ("sq" cider-quit)
  ("sr" cider-send-region-to-repl)
  ("sR" cider-send-region-to-repl-focus)
  ("q" nil))


;; HASKELL


(major-mode-hydra-bind haskell-mode "REPL"
  ("sb" haskell-process-load-file)
  ("hp" dante-info)
  ("ht" dante-type-at)
  ("q" nil))

(use-package haskell-mode
  :mode ("\\.hs\\'" . haskell-mode)
  :ensure t)

(use-package company-cabal
  :mode ("\\.hs\\'" . haskell-mode)
  :ensure t
  :config
  (add-to-list 'company-backends #'company-cabal)
  )



(use-package flycheck-haskell
  :mode ("\\.hs\\'" . haskell-mode)
  :ensure t)

(add-hook 'haskell-mode-hook #'flycheck-haskell-setup)

(use-package dante
  :mode ("\\.hs\\'" . haskell-mode)
  :ensure t
  :hook (haskell-mode-local-vars . dante-mode)
  :init
  (setq dante-load-flags '(;; defaults:
                           "+c"
                           "-Wwarn=missing-home-modules"
                           "-fno-diagnostics-show-caret"
                           ;; neccessary to make attrap-attrap useful:
                           "-Wall"
                           ;; necessary to make company completion useful:
                           "-fdefer-typed-holes"
			   "-fdefer-type-errors"))
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'dante-mode)

  (add-hook 'haskell-mode-hook 'company-mode))


(add-hook 'dante-mode-hook
   '(lambda () (flycheck-add-next-checker 'haskell-dante
                '(warning . haskell-hlint))))

;; https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

;; LATEX

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . laTeX-mode)
  :config
  (setq TeX-auto-save t))

(use-package auctex-latexmk
  :after latex
  :mode ("\\.tex\\'" . laTeX-mode)
  :ensure t
  :init
  ;; Pass the -pdf flag when TeX-PDF-mode is active
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  ;; Set LatexMk as the default
  :config
  ;; Add latexmk as a TeX target
  (auctex-latexmk-setup))

(use-package company-auctex
  :mode ("\\.tex\\'" . laTeX-mode)
  :ensure t)

(company-auctex-init)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)


;; Set latexmk as default
(add-hook 'Latex-mode-hook (setq TeX-command-default "LatexMk"))

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(major-mode-hydra-bind latex-mode "Compilation"
  ("pc" TeX-command-master)
  ("pv" (lambda () (interactive) (TeX-view "skim")))
  ("q" nil))




;; Fontification taken from https://tex.stackexchange.com/a/86119/81279
(setq font-latex-match-reference-keywords
      '(;; biblatex
        ("printbibliography" "[{")
        ("addbibresource" "[{")
        ;; Standard commands
        ("cite" "[{")
        ("citep" "[{")
        ("citet" "[{")
        ("Cite" "[{")
        ("parencite" "[{")
        ("Parencite" "[{")
        ("footcite" "[{")
        ("footcitetext" "[{")
        ;; Style-specific commands
        ("textcite" "[{")
        ("Textcite" "[{")
        ("smartcite" "[{")
        ("Smartcite" "[{")
        ("cite*" "[{")
        ("parencite*" "[{")
        ("supercite" "[{")
        ;; Qualified citation lists
        ("cites" "[{")
        ("Cites" "[{")
        ("parencites" "[{")
        ("Parencites" "[{")
        ("footcites" "[{")
        ("footcitetexts" "[{")
        ("smartcites" "[{")
        ("Smartcites" "[{")
        ("textcites" "[{")
        ("Textcites" "[{")
        ("supercites" "[{")
        ;; Style-independent commands
        ("autocite" "[{")
        ("Autocite" "[{")
        ("autocite*" "[{")
        ("Autocite*" "[{")
        ("autocites" "[{")
        ("Autocites" "[{")
        ;; Text commands
        ("citeauthor" "[{")
        ("Citeauthor" "[{")
        ("citetitle" "[{")
        ("citetitle*" "[{")
        ("citeyear" "[{")
        ("citedate" "[{")
        ("citeurl" "[{")
        ;; Special commands
        ("fullcite" "[{")
        ;; cleveref
        ("cref" "{")
        ("Cref" "{")
        ("cpageref" "{")
        ("Cpageref" "{")
        ("cpagerefrange" "{")
        ("Cpagerefrange" "{")
        ("crefrange" "{")
        ("Crefrange" "{")
        ("labelcref" "{")))

(setq font-latex-match-textual-keywords
      '(;; biblatex brackets
        ("parentext" "{")
        ("brackettext" "{")
        ("hybridblockquote" "[{")
        ;; Auxiliary Commands
        ("textelp" "{")
        ("textelp*" "{")
        ("textins" "{")
        ("textins*" "{")
        ;; subcaption
        ("subcaption" "[{")))

(setq font-latex-match-variable-keywords
      '(;; amsmath
        ("numberwithin" "{")
        ;; enumitem
        ("setlist" "[{")
        ("setlist*" "[{")
        ("newlist" "{")
        ("renewlist" "{")
        ("setlistdepth" "{")
        ("restartlist" "{")
        ("crefname" "{")))



;; Shell

(use-package shell-pop
  :ensure t
  :config
  (setq shell-pop-shell-type '("ansi-term" "*ansi-term*" (lambda nil (term))))
  (setq shell-pop-term-shell fish-location)
  )


;; Fish is the default shell
(setq explicit-shell-file-name fish-location)




;; Python

;; https://emacs.stackexchange.com/questions/30082/your-python-shell-interpreter-doesn-t-seem-to-support-readline
(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))


(use-package elpy
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i"))


(use-package eval-sexp-fu
  :ensure t
  :config
  (setq eval-sexp-fu-flash-mode t))

(major-mode-hydra-bind python-mode "REPL"
  ("se" elpy-shell-send-statement-and-step-and-go)
  ("sf" elpy-shell-send-defun-and-go)
  ("sb" elpy-shell-send-buffer-and-go)
  ("q" nil))


;; Common LISP

(use-package slime
  :ensure t
  :mode ("\\.lsp\\'" . lisp-mode)
  :config
  (setq inferior-lisp-program sbcl-location)
  (add-to-list 'slime-contribs 'slime-repl))



(major-mode-hydra-bind lisp-mode "REPL"
  ("se" slime-eval-last-expression)
  ("sf" slime-eval-defun)
  ("sb" slime-eval-buffer)
  ("q" nil))



;; add /usr/local/bin to PATH
(setenv "PATH" (concat "/usr/local/bin" path-separator (getenv "PATH")))
(add-to-list 'exec-path "/usr/local/bin")


(provide 'init)
;;; init.el ends here


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(slime shell-pop sly elisp-format org-evil monitor eval-sexp-fu elpy projectile tex company-auctex auctex-latexmk latex-preview-pane which-key use-package treemacs-evil org-plus-contrib noflet major-mode-hydra general flycheck-haskell exec-path-from-shell evil-surround evil-numbers evil-nerd-commenter evil-matchit evil-iedit-state evil-collection el-patch doom-themes doom-modeline dash-functional dante counsel company-cabal cider auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
