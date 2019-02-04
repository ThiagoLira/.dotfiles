(eval-when-compile
  (require 'use-package))


(require 'general)

(use-package major-mode-hydra
  :straight t
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
 "SPC" '(avy-goto-word-or-subword-1  :which-key "go to char")

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




(provide 'th-hydras)
