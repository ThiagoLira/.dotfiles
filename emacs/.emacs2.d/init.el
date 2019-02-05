(setq user-emacs-directory "~/.emacs2.d/")

(setq gc-cons-threshold (* 800 1024))

(defconst emacs-start-time (current-time))

(unless noninteractive
  (message "Loading %s..." load-file-name))

(setenv "INSIDE_EMACS" "true")


;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; bootstrap use-package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             '("marmalade" . "http://marmalade-repo.org/packages/")
             )
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
    (evil-ex-define-cmd "spell" #'config-evil-flyspell-on)

    ;; Better compat with smartparens-strict mode.
    ;; TODO: Move to SP config.

    (advice-add #'evil-delete-backward-char-and-join
                :around #'config-evil--sp-delete-and-join-compat)))


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



(general-define-key
 :states '(normal visual insert emacs)
 :prefix "SPC"
 :non-normal-prefix "C-SPC"

 ;; simple command
    "'"   '(iterm-focus :which-key "iterm")
    "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
    "/"   'counsel-ag
    "TAB" '(switch-to-other-buffer :which-key "prev buffer")
    "SPC" 'counsel-M-x
 ;; Buffer operations
    "b"   '(:ignore t :which-key "buffer")
    "bb"  'mode-line-other-buffer
    "bd"  'kill-this-buffer
    "b]"  'next-buffer
    "b["  'previous-buffer
    "bq"  'kill-buffer-and-window
    "bR"  'rename-file-and-buffer
    "br"  'revert-buffer

 ;; bind to double key press
  "ff"  'counsel-find-file  ; find file using ivy
  "fr"	'counsel-recentf    ; find recently edited files
  "pf"  'counsel-git        ; find file in git project
 ;; Applications
 "a" '(:ignore t :which-key "Applications")
 "ar" 'ranger
 "ad" 'dired
 "w" 'hydra-window/body
 "<f2>" 'hydra-zoom/body
 )


(defhydra hydra-window (:color red
                        :hint nil)
  "
 Split: _v_ert _x_:horz
Delete: _o_nly  _da_ce  _dw_indow  _db_uffer  _df_rame
  Move: _s_wap
Frames: _f_rame new  _df_ delete
  Misc: _m_ark _a_ce  _u_ndo  _r_edo"
  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)
  ("H" hydra-move-splitter-left)
  ("J" hydra-move-splitter-down)
  ("K" hydra-move-splitter-up)
  ("L" hydra-move-splitter-right)
  ("|" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right)))
  ("_" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down)))
  ("v" split-window-right)
  ("x" split-window-below)
  ;("t" transpose-frame "'")
  ;; winner-mode must be enabled
  ("u" winner-undo)
  ("r" winner-redo) ;;Fixme, not working?
  ("o" delete-other-windows :exit t)
  ("a" ace-window :exit t)
  ("f" new-frame :exit t)
  ("s" ace-swap-window)
  ("da" ace-delete-window)
  ("dw" delete-window)
  ("db" kill-this-buffer)
  ("df" delete-frame :exit t)
  ("q" nil)
  ;("i" ace-maximize-window "ace-one" :color blue)
  ;("b" ido-switch-buffer "buf")
  ("m" headlong-bookmark-jump))


(defhydra hydra-zoom (:color green)
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))


(major-mode-hydra-bind emacs-lisp-mode "Eval"
                       ("ee" eval-last-sexp "sexp")
                       ("eb" eval-buffer "buffer")
                       ("ed" eval-defun "defun")
                       ("er" eval-region "region"))



