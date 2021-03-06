;; -*- coding: utf-8 -*-
(require 'wttr-utils)

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
(wttr/plugin:prepend-to-load-path "evil")
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

;; some auto load
(autoload 'dired-jump "dired" "dired-jump" t)
(autoload 'dired-jump-other-window "dired" "dired-jump" t)
;; add ";" sub map
(define-prefix-command 'wttr/my-evil-normal-map)
(define-key evil-normal-state-map (kbd ";") 'wttr/my-evil-normal-map)
(mapc (lambda (info)
        (define-key wttr/my-evil-normal-map
          (read-kbd-macro (car info))
          (cdr info)))
      '(
        ("d" . ido-dired)
        ("E" . eshell)
        ("e" . kid-switch-to-shell)
        ("f" . ido-find-file)
        ("r" . revert-buffer-with-coding-system)
        ("4" . wttr/kill-buffer-may-have-clients)
        ("k" . ido-kill-buffer)
        ("o" . other-window)
        ("w" . ido-write-file)
        ("b" . ido-switch-buffer)
        ("B" . ido-switch-buffer-other-window)
        ("n" . next-buffer)
        ("p" . previous-buffer)
        ("s" . save-buffer)
        ("g" . wttr/customized:rgrep)
        ("a" . wttr/customized:rgrep-using-ack)
        ("l" . ibuffer)
        ("j" . dired-jump )
        ("J" . dired-jump-other-window )
        ("i" . ispell-buffer)
        ("m" . magit-status)
        ("c" . codesearch-search)
        ("x" . codesearch-search-at-point)
      ))

(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)
;; opposite to C-o : evil-jump-backward
(define-key evil-normal-state-map (kbd "TAB") 'evil-jump-forward)
;; opposite to u : undo-tree-undo
(define-key evil-normal-state-map (kbd "C-r") 'undo-tree-redo)

;; replace the <c-e> to move-end-of-line
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)

;; we do not need c-n and c-p to evil-complete
(define-key evil-insert-state-map (kbd "C-n") 'next-line)
(define-key evil-insert-state-map (kbd "C-p") 'previous-line)

;; recover the c-k, do not trigger special char input as vim
(define-key evil-insert-state-map (kbd "C-k") 'kill-line)
;; recover the c-y, yank
(define-key evil-insert-state-map (kbd "C-y") 'yank)



;; some mode that should use emacs state
(dolist (mode '(dired-mode
                eassist-mode
                gtags-select-mode
                magit-status-mode
                magit-log-mode
                magit-commit-mode
                magit-diff-mode))
  (add-to-list 'evil-emacs-state-modes mode))


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
