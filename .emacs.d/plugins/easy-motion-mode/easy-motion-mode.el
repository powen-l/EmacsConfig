;;; easy-motion-mode.el --- a quick locate function in current view

;; Copyright (C) 2011 Free Software Foundation, Inc.

;; Author:   winterTTr <winterTTr@gmail.com>
;; Keywords: motion, location, cursor

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;; INTRODUCTION
;;
;; gsl-mode is a emacs port version of EasyMotion plugin in vim.


;;; register as a minor mode
(or (assq 'easy-motion-mode minor-mode-alist)
    (nconc minor-mode-alist
          (list '(easy-motion-mode easy-motion-mode))))


;;; some buffer specific global variable
(defvar easy-motion-mode nil
  "Mode variable for EasyMotion minor mode.")
(defvar easy-motion-overlay-foreground-list nil
  "overlay to cover the selective character")
(defvar easy-motion-overlay-background nil
  "overlay to cover the current whole window")
(defvar easy-motion-move-keys
  (let ( (i 0)
         (l nil) )
    ;; add a-z
    (setq i ?a)
    (while (<= i ?z)
      (setq l (nconc l (list i)))
      (setq i (+ 1 i)))
    ;; add A-Z
    (setq i ?A)
    (while (<= i ?Z)
      (setq l (nconc l (list i)))
      (setq i (+ 1 i)))
    l)
  "possible location keys when move cursor") 


(make-variable-buffer-local 'easy-motion-mode)
(make-variable-buffer-local 'easy-motion-overlay-foreground-list)
(make-variable-buffer-local 'easy-motion-overlay-background)


;;; key binding for easy motion mode
(define-key global-map (kbd "C-x SPC") 'easy-motion-mode)  
(define-key global-map (kbd "C-c SPC") 'easy-motion-mode)  


;;; define the face
(defface easy-motion-face-background
  '( (t (:foreground "gray40") )
     )
  "face for background of easy motion")


(defface easy-motion-face-foreground
  '( ( ((class color) (background dark))
       (:foreground "red") )
     (t (:foreground "gray100") )
     )
  "face for foreground of easy motion")

(defvar easy-motion-mode-map 
  (let ( (map (make-keymap)) )
    (dolist (key-code easy-motion-move-keys)
      (define-key map (make-string 1 key-code) 'easy-motion-move))
    (define-key map [t] 'easy-motion-done)
    map)
  "easy motion key map")


(defvar easy-motion-mode-hook nil
  "Funciton(s) to call after start easy motion mode")

(defvar easy-motion-mode-end-hook nil
  "Funciton(s) to call after stop easy motion mode")

(defun easy-motion-query-char-p ( query-char )
  "check if the query char is valid"
  (or (and (>= query-char ?a) (<= query-char ?z))
      (and (>= query-char ?A) (<= query-char ?Z))))


(defun easy-motion-mode-do( query-char )
  "enter easy motion mode, init easy motion settings"
  (setq easy-motion-mode " EasyMotion")
  (force-mode-line-update)

  (let* ((current-window (selected-window))
         (start-point (window-start current-window))
         (end-point   (window-end   current-window))
         (query-char-position-list nil) )
    (message (format "start point:%d" start-point))
    (message (format "end point:%d" end-point))
    ;; create background overlay
    (setq easy-motion-overlay-background
          (make-overlay start-point end-point (current-buffer)))
    (overlay-put easy-motion-overlay-background 'face 'easy-motion-face-background)

    ;; search possible value of query char
    (save-excursion
      (goto-char start-point)
      (let ((case-fold-search nil))
        (while (search-forward (char-to-string query-char) end-point t)
          (setq query-char-position-list
                (nconc query-char-position-list (list (match-beginning 0))))
          ) ;; while
        ) ;; let
      ) ;; save-excursion
    ;; make foreground overlay
    (dolist (pos query-char-position-list)
      (let ( (ol (make-overlay pos (1+ pos) (current-buffer))) )
        (print ol)
        (overlay-put ol 'face 'easy-motion-face-foreground)
        (overlay-put ol 'display "X")
        (setq easy-motion-overlay-foreground-list
              (nconc easy-motion-overlay-foreground-list (list ol)))
        );; let
      );; dolist
    (print (length easy-motion-overlay-foreground-list))
    ) ;; let *

  ;; override the local key map
  (setq overriding-local-map easy-motion-mode-map)
  (run-hooks 'easy-motion-mode-hook)

  (add-hook 'mouse-leave-buffer-hook 'easy-motion-done)
  (add-hook 'kbd-macro-termination-hook 'easy-motion-done)
  ) ;; defun  

(defun easy-motion-mode ( query-char )
  "EasyMotion mode"
  (interactive "cQuery Char:")
  (if (easy-motion-query-char-p query-char)
      (easy-motion-mode-do query-char)
      (error "not invalid query char")
    ) ;; if
  ) ;; defun

(defun easy-motion-move ()
  "move cursor based on user input"
  (interactive)
  (let ( (key-code (aref (this-command-keys) 0)) )
    (when (member key-code easy-motion-move-keys)
      (message (format "easy-motion-move :%s" (this-command-keys)))
      );;when
    );;let
  (easy-motion-done)
  )  


(defun easy-motion-done()
  "stop easy motion"
  (interactive)
  (setq easy-motion-mode nil)
  (force-mode-line-update)

  (if easy-motion-overlay-background
      (delete-overlay easy-motion-overlay-background))
  (setq easy-motion-overlay-background nil)

  (dolist (ol easy-motion-overlay-foreground-list)
    (delete-overlay ol))
  (setq easy-motion-overlay-foreground-list nil)

  (setq overriding-local-map nil)
  (run-hooks 'easy-motion-mode-end-hook)

  (remove-hook 'mouse-leave-buffer-hook 'easy-motion-done)
  (remove-hook 'kbd-macro-termination-hook 'easy-motion-done)

  )


