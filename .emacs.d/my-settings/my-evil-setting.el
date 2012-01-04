;; -*- coding: utf-8 -*-

;;;; pre setting
(setq-default evil-auto-indent t)
(setq evil-shift-width 4)
(setq evil-repeat-move-cursor t)
(setq evil-find-skip-newlines nil)
(setq evil-move-cursor-back t)
(setq evil-want-fine-undo nil)
(setq evil-regexp-search t)
(setq evil-search-wrap t)
(setq evil-flash-delay 3)
(setq evil-want-C-i-jump nil)
(setq evil-want-C-u-scroll nil)

;; load
(add-to-list 'load-path "~/.emacs.d/plugins/evil")
(require 'evil)
(evil-mode 1)

;;;; cursor appearance
;evil-default-cursor [Variable]
;The default cursor.
;evil-normal-state-cursor [Variable]
;The cursor for Normal state.
;evil-insert-state-cursor [Variable]
;The cursor for Insert state.
;evil-visual-state-cursor [Variable]
;The cursor for Visual state.
;evil-replace-state-cursor [Variable]
;The cursor for Replace state.
;evil-operator-state-cursor [Variable]
;The cursor for Operator-Pending state.
;evil-motion-state-cursor [Variable]
;The cursor for Motion state.
;evil-emacs-state-cursor [Variable]
;The cursor for Emacs state.

;;;; initial state
;evil-set-initial-state

;;;; key map 
;evil-normal-state-map [Variable]
;The global keymap for Normal state.
(define-key evil-normal-state-map (kbd "C-s") 'save-buffer)

(defun my-kill-buffer ()
  (interactive)
  (if (and (boundp 'server-buffer-clients)
           server-buffer-clients)
      (server-kill-buffer))
  (kill-buffer (current-buffer)))

(define-prefix-command 'wttr/space-evil-normal-map)
(define-key evil-normal-state-map (kbd "SPC") 'wttr/space-evil-normal-map)
(mapc (lambda (info)
        (define-key wttr/space-evil-normal-map
          (read-kbd-macro (car info))
          (cdr info)))
      '(
        ("d" . ido-dired)
        ("f" . ido-find-file)
        ("r" . revert-buffer-with-coding-system)
        ("c" . my-kill-buffer)
        ("k" . ido-kill-buffer)
        ("o" . other-window)
        ("w" . ido-write-file)
        ("b" . ido-switch-buffer)
        ("B" . ido-switch-buffer-other-window)
        ("n" . next-buffer)
        ("p" . previous-buffer)
        ("s" . save-buffer)
        ("g" . rgrep)
        ("l" . ibuffer)
        ("j" . dired-jump )
        ("J" . dired-jump-other-window )
        ("SPC" . ace-jump-mode)
      ))

;; replace the <c-e> to move-end-of-line
(substitute-key-definition 'evil-copy-from-below 'move-end-of-line evil-insert-state-map)

(add-to-list 'evil-emacs-state-modes 'dired-mode)
  
;evil-insert-state-map [Variable]
;The global keymap for Insert state.
;evil-visual-state-map [Variable]
;The global keymap for Visual state.
;evil-replace-state-map [Variable]
;The global keymap for Replace state.
;evil-operator-state-map [Variable]
;The global keymap for Operator-Pending state.
;evil-motion-state-map [Variable]
;The global keymap for Motion state.

;evil-normal-state-local-map [Variable]
;Buffer-local keymap for Normal state.
;evil-insert-state-local-map [Variable]
;Buffer-local keymap for Insert state.
;evil-visual-state-local-map [Variable]
;Buffer-local keymap for Visual state.
;evil-replace-state-local-map [Variable]
;Buffer-local keymap for Replace state.
;evil-operator-state-local-map [Variable]
;Buffer-local keymap for Operator-Pending state.
;evil-motion-state-local-map [Variable]
;Buffer-local keymap for Motion state.



;;;; hooks
;evil-normal-state-entry-hook [Variable]
;Run when entering Normal state.
;evil-normal-state-exit-hook [Variable]
;Run when exiting Normal state.
;evil-insert-state-entry-hook [Variable]
;Run when entering Insert state.
;evil-insert-state-exit-hook [Variable]
;Run when exiting Insert state.
;evil-visual-state-entry-hook [Variable]
;Run when entering Visual state.
;evil-visual-state-exit-hook [Variable]
;Run when exiting Visual state.
;evil-replace-state-entry-hook [Variable]
;Run when entering Replace state.
;evil-replace-state-exit-hook [Variable]
;Run when exiting Replace state.
;evil-operator-state-entry-hook [Variable]
;Run when entering Operator-Pending state.
;evil-operator-state-exit-hook [Variable]
;Run when exiting Operator-Pending state.
;evil-motion-state-entry-hook [Variable]
;Run when entering Motion state.
;evil-motion-state-exit-hook [Variable]
;Run when exiting Motion state.

;; evil-next-state [Variable]
;; The state being switched to.
;; evil-previous-state [Variable]
;; The state being switched from.

(provide 'my-evil-setting)
