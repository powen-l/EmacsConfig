(setq viper-expert-level 5)

(setq viper-inhibit-startup-message 't)
(setq-default require-final-newline 't)

(setq-default viper-auto-indent 't)
(setq-default viper-electric-mode 't)
(setq viper-case-fold-search 't)
(setq viper-re-search 't)
(setq blink-matching-paren 't)
(setq-default tab-width 4)
(setq viper-shift-width 8)
(setq viper-search-wrap-around 't)
(setq viper-tags-file-name "TAGS")
(setq viper-re-query-replace 't)
(setq viper-want-ctl-h-help 't)
(setq viper-vi-style-in-minibuffer nil)
(setq viper-no-multiple-ESC 't)
(setq viper-fast-keyseq-timeout 200)
(setq viper-ex-style-motion nil)
(setq viper-ex-style-editing nil)
(setq viper-ESC-move-cursor-back t)
(setq viper-always t)
(setq viper-custom-file-name "~/.viper")
(setq viper-spell-function 'ispell-region)
;viper-glob-function
(setq ex-cycle-other-window t)
(setq ex-cycle-through-non-files t)
(setq viper-want-emacs-keys-in-insert t)
(setq viper-want-emacs-keys-in-vi t)
(setq viper-keep-point-on-repeat nil)
(setq viper-keep-point-on-undo nil)
(setq viper-delete-backwards-in-replace t)
;viper-replace-overlay-face
;viper-replace-overlay-cursor-color
;viper-insert-state-cursor-color
;viper-emacs-state-cursor-color
;viper-replace-region-end-delimiter
;viper-replace-region-start-delimiter
;viper-use-replace-region-delimiters
(setq viper-allow-multiline-replace-regions t)
;viper-toggle-key "\C-z"
;viper-surrounding-word-function
;viper-search-face
;viper-vi-state-hook
;viper-insert-state-hook
;viper-replace-state-hook
;viper-emacs-state-hook
;viper-load-hook

;viper-vi-global-user-map
;viper-insert-global-user-map
;viper-emacs-global-user-map


;; change key in specific mode
;(setq my-dired-modifier-map (make-sparse-keymap))
;(define-key my-dired-modifier-map "dd" 'dired-flag-file-deletion)
;(define-key my-dired-modifier-map "u" 'dired-unmark)
;(viper-modify-major-mode 'dired-mode 'vi-state my-dired-modifier-map)

;viper-buffer-search-char
;(viper-buffer-search-enable)
;viper-minibuffer-vi-face
(copy-face 'default 'viper-minibuffer-vi-face)
(copy-face 'default 'viper-minibuffer-insert-face)
(copy-face 'default 'viper-minibuffer-emacs-face)
