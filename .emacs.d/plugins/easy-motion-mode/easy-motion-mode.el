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

(require 'cl)

;;; register as a minor mode
(or (assq 'easy-motion-mode minor-mode-alist)
    (nconc minor-mode-alist
          (list '(easy-motion-mode easy-motion-mode))))


;;; some buffer specific global variable
(defvar easy-motion-mode nil
  "Mode variable for EasyMotion minor mode.")
(defvar easy-motion-overlays nil
  "store all the overlay that created by easy motion
The first one is background overlay, and the cdr is forground overlay")
(defvar easy-motion-search-tree nil
  "we create the search tree for all possible positions")

(make-variable-buffer-local 'easy-motion-mode)
(make-variable-buffer-local 'easy-motion-overlays)
(make-variable-buffer-local 'easy-motion-search-tree)

;(defconst easy-motion-move-keys
;  (nconc (loop for i from ?a to ?z collect i)
;         (loop for i from ?A to ?Z collect i))
;  "possible location keys when move cursor") 
(defconst easy-motion-move-keys
  (nconc (loop for i from ?1 to ?3 collect i) )
  "possible location keys when move cursor") 


;;; key binding for easy motion mode
(define-key global-map (kbd "C-x SPC") 'easy-motion-mode)  
(define-key global-map (kbd "C-c SPC") 'easy-motion-mode)  


;;; define the face
(defface easy-motion-face-background
  '((t (:foreground "gray40")))
  "face for background of easy motion")


(defface easy-motion-face-foreground
  '((((class color) (background dark)) (:foreground "red"))
     (t (:foreground "gray100"))) 
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
  "check if the query char is valid, we now only use printable ascii char"
  (and (> query-char #x1F) (< query-char #x7F)) )

(defun easy-motion-search-candidate( query-string )
  "search the query-string in current view, and return the candidate position list"
  (let* ((current-window (selected-window))
         (start-point (window-start current-window))
         (end-point   (window-end   current-window)) )
    (save-excursion
      (goto-char start-point)
      (let ((case-fold-search nil)) ;; use case sensitive search
        (loop while (search-forward query-string end-point t)
                    collect (match-beginning 0))))) )

(defun easy-motion-construct-search-tree ( candidate-sum )
  "Constrct the search tree"
  )


(defun easy-motion-do( query-string )
  "enter easy motion mode, init easy motion settings"
  ;; search candidate position
  (let ((candidate-list (easy-motion-search-candidate query-string)))
    (cond
     ;; cannot find any one
     ((null candidate-list)
      (error "There is no such character"))
     ;; we only find one, so move to it directly
     ((= (length candidate-list) 1)
      (goto-char (car candidate-list))
      (message "Move to the only one directly"))
     ;; more than one, we need to enter easy motion mode
     (t
      (setq easy-motion-search-tree
            (easy-motion-construct-search-tree (length candidate-list)))
      
      (print easy-motion-search-tree)
      ;(easy-motion-update nil)

      ;; do minor mode configuration
      (setq easy-motion-mode " EasyMotion")
      (force-mode-line-update)

      ;; override the local key map
      (setq overriding-local-map easy-motion-mode-map)
      (run-hooks 'easy-motion-mode-hook)

      (add-hook 'mouse-leave-buffer-hook 'easy-motion-done)
      (add-hook 'kbd-macro-termination-hook 'easy-motion-done)))))
    ;;; create background overlay
    ;(setq easy-motion-overlays
    ;      (list
    ;       (let ( (ol (make-overlay start-point end-point (current-buffer))) )
    ;         (overlay-put ol 'face 'easy-motion-face-background)
    ;         ol)))

    ;;; make foreground overlay
    ;(setq easy-motion-overlays
    ;      (nconc easy-motion-overlays
    ;             (loop for pos in candidate-position-list
    ;                   collect (let ( (ol (make-overlay pos (1+ pos) (current-buffer))) )
    ;                             (overlay-put ol 'face 'easy-motion-face-foreground)
    ;                             ;(overlay-put ol 'display (concat "X"))
    ;                             ol)))))


;(defun easy-motion-update ( query-char )
;  "update the overlay based on the easy-motion-move-keys setting and input query"
;  (if (not (null query-char))
;    ;; filter the query-char item
;    (let* ((query-string (make-string 1 query-char))
;           (retain-ols (loop for ol in (cdr easy-motion-overlays)
;                              if (string= (overlay-get ol 'display) query-string)
;                              collect ol))
;           (discard-ols (loop for ol in (cdr easy-motion-overlays)
;                              if (not (memq ol retain-ols))
;                              collect ol)) )
;      (mapcar #'delete-overlay discard-ols)
;      (setq easy-motion-overlays
;            (cons (car easy-motion-overlays) retain-ols))))
; 
;  ;; update the display property based on the user input
;  (let* ( (ols (cdr easy-motion-overlays))
;          (ols-length (length ols)) )
;    nil)
;    )


(defun easy-motion-mode ( query-char )
  "EasyMotion mode"
  (interactive "cQuery Char:")
  (if (easy-motion-query-char-p query-char)
      (easy-motion-do (make-string 1 query-char))
      (error "not invalid query char")))

(defun easy-motion-move ()
  "move cursor based on user input"
  (interactive)
  (let ( (key-code (aref (this-command-keys) 0)) )
    (when (member key-code easy-motion-move-keys)
      (message (format "easy-motion-move :%s" (this-command-keys)))))
  (easy-motion-done))  


(defun easy-motion-done()
  "stop easy motion"
  (interactive)
  (setq easy-motion-mode nil)
  (force-mode-line-update)

  (mapcar #'delete-overlay easy-motion-overlays)
  (setq easy-motion-overlays nil)

  (setq overriding-local-map nil)
  (run-hooks 'easy-motion-mode-end-hook)

  (remove-hook 'mouse-leave-buffer-hook 'easy-motion-done)
  (remove-hook 'kbd-macro-termination-hook 'easy-motion-done))
  


;;;; ============================================
;;;; Utilities for easy-motion-mode
;;;; ============================================

(defstruct em-queue head tail)

(defun em-queue-push (item q)
  "enqueue"
  (let ( (head (em-queue-head q) )
         (tail (em-queue-tail q) )
         (c (list item) ) )
    (cond
     ((null (em-queue-head q))
      (setf (em-queue-head q) c)
      (setf (em-queue-tail q) c))
     (t
      (setf (cdr (em-queue-tail q)) c)
      (setf (em-queue-tail q) c)))))

    
