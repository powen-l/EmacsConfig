;;; easy-motion-mode.el --- a quick cursor location minor mode for emacs

;; Copyright (C) 2011 Free Software Foundation, Inc.

;; Author   : winterTTr <winterTTr@gmail.com>
;; version  : 1.0
;; Keywords : motion, location, cursor

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

;;; INTRODUCTION
;;

;; What's EasyMotion ?
;; 
;;   It is a insteresting plugin in vim. EasyMotion provides a much
;; simpler way to use some motions in vim. It takes the <number> out
;; of <number>w or <number>f{char} by highlighting all possible
;; choices and allowing you to press one key to jump directly to the
;; target.
;;

;; What's easy-motion-mode ?
;;
;;   easy-motion-mode is a emacs port version of EasyMotion plugin.
;;

;; Do you implement everything ?
;;
;;   Currently not, and I don't want to make it exactly as it in
;; vim. I think the moving style itself is really cool, so I rewrite
;; it in emacs. But I do not mean to copy everyting.
;;   So, in this version, there is only one kind of motion, only a
;; character search mode. I think that is enough for normal case.
;; But if you want the word mode, feel free to tell me at any time.
;; I will add that to my TODO list :D
;; 
;;; Usage
;; 
;; Add the following code to your init file, of course you can select
;; the key which you prefer to.
;; ----------------------------------------------------------
;; (add-to-list 'load-path "which-folder-this-file-in/")
;; (autoload
;;   'easy-motion-mode
;;   "easy-motion-mode"
;;   "Emacs easy motion minor mode"
;;   t)
;; (define-key global-map (kbd "C-c SPC") 'easy-motion-mode)
;;
;; ;;If you also use viper mode :
;; (define-key viper-vi-global-user-map (kbd "SPC") 'easy-motion-mode)
;; ----------------------------------------------------------
;;
;; If you want your own moving keys, you can custom that as follow,
;; for example, you only want to use lower case character:
;;
;; (setq easy-motion-move-keys
;;       (loop for i from ?a to ?z collect i))
;;
;; Please make sure, add this setting before easy-motion-mode is loaded.
;;

(require 'cl)

;;; register as a minor mode
(or (assq 'easy-motion-mode minor-mode-alist)
    (nconc minor-mode-alist
          (list '(easy-motion-mode easy-motion-mode))))


;;; some buffer specific global variable
(defvar easy-motion-mode nil
  "EasyMotion minor mode.")
(defvar easy-motion-background-overlay nil
  "Background overlay which will grey all the display")
(defvar easy-motion-search-tree nil
  "N-branch Search tree for all possible positions")

(make-variable-buffer-local 'easy-motion-mode)
(make-variable-buffer-local 'easy-motion-background-overlay)
(make-variable-buffer-local 'easy-motion-search-tree)

(defvar easy-motion-move-keys
  (nconc (loop for i from ?a to ?z collect i)
         (loop for i from ?A to ?Z collect i))
  "possible location keys when move cursor") 


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

(defun easy-motion-tree-breadth-first-construct (total-leaf-node max-child-node)
  "Constrct the search tree, each item in the tree is a cons cell.
The (car tree-node) is the type, which should be only 'branch or 'leaf.
The (cdr tree-node) is data stored in a leaf when type is 'leaf,
while a child node list when type is 'branch"
  (let ((left-leaf-node (- total-leaf-node 1))
        (q (make-em-queue))
        (node nil)
        (root (cons 'leaf nil)) )
    ;; we push the node into queue and make candidate-sum -1, so
    ;; create the start condition for the while loop
    (em-queue-push root q)
    (while (> left-leaf-node 0)
      (setq node (em-queue-pop q))
      ;; when a node is picked up from stack, it will be changed to a
      ;; branch node, we lose a leaft node
      (setf (car node) 'branch)
      ;; so we need to add the sum of leaf nodes that we wish to create
      (setq left-leaf-node (1+ left-leaf-node))
      (if (<= left-leaf-node max-child-node)
          ;; current child can fill the left leaf
          (progn 
            (setf (cdr node)
                  (loop for i from 1 to left-leaf-node
                        collect (cons 'leaf nil)))
            ;; so this should be the last action for while
            (setq left-leaf-node 0))
        ;; the child can not cover the left leaf
        (progn
          ;; fill as much as possible. Push them to queue, so it have
          ;; the oppotunity to become 'branch node if necessary
          (setf (cdr node)
                (loop for i from 1 to max-child-node
                      collect (let ((n (cons 'leaf nil)))
                                (em-queue-push n q)
                                n)))
          (setq left-leaf-node (- left-leaf-node max-child-node)))))
    ;; return the root node
    root)) 

(defun easy-motion-tree-preorder-traverse (tree &optional leaf-func branch-func)
  "we move over tree by depth first, and call `branch-func' on each branch node
and call `leaf-func' on each leaf node"
  ;; use stack to do preorder traverse
  (let ((s (list tree)))
    (while (not (null s))
      ;; pick up one from stack
      (let ((node (car s)))
        ;; update stack
        (setq s (cdr s))
        (cond
         ((eq (car node) 'branch)
            ;; a branch node
          (if branch-func
              (funcall branch-func node))
          ;; push all child node into stack
          (setq s (append (cdr node) s)))
         ((eq (car node) 'leaf)
          (if leaf-func
              (funcall leaf-func node)))
         (t
          (error "invalid tree node type"))))))) 

        
(defun easy-motion-populate-overlay-to-search-tree (tree candidate-list)
  "we populate the overlay to search tree recursively (depth first)"
  (let* ((position-list candidate-list)
         (func-create-overlay (lambda (node)
                                (let* ((pos (car position-list))
                                       (ol (make-overlay pos (1+ pos) (current-buffer))))
                                  (setf (cdr node) ol)
                                  (overlay-put ol 'face 'easy-motion-face-foreground)
                                  (setq position-list (cdr position-list))))))
    (easy-motion-tree-preorder-traverse tree func-create-overlay)
    tree))
  

(defun easy-motion-delete-overlay-in-search-tree (tree)
  "We delete all the overlay in search tree leaf node recursively (depth first)"
  (let ((func-delete-overlay (lambda (node)
                               (delete-overlay (cdr node))
                               (setf (cdr node) nil))))
    (easy-motion-tree-preorder-traverse tree func-delete-overlay)))

     
(defun easy-motion-update-overlay-in-search-tree (tree keys)
  "we update overlay 'display property using each name in keys"
  (let ((func-update-overlay (lambda (node)
                                (overlay-put (cdr node)
                                             'display
                                             (make-string 1 key)))))
    (loop for k in keys
          for n in (cdr tree)
          do (let ((key k))
               (if (eq (car n) 'branch)
                   (easy-motion-tree-preorder-traverse n
                                                       func-update-overlay)
                 (funcall func-update-overlay n))))))
               

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
      ;; create background
      (setq easy-motion-background-overlay
            (make-overlay (window-start (selected-window))
                          (window-end   (selected-window))
                          (current-buffer)))
      (overlay-put easy-motion-background-overlay 'face 'easy-motion-face-background)

      ;; construct search tree and populate overlay into tree
      (setq easy-motion-search-tree (easy-motion-tree-breadth-first-construct
                                     (length candidate-list)
                                     (length easy-motion-move-keys)))
      (easy-motion-populate-overlay-to-search-tree easy-motion-search-tree
                                                   candidate-list)
      (easy-motion-update-overlay-in-search-tree easy-motion-search-tree
                                                 easy-motion-move-keys)
      
      ;; do minor mode configuration
      (setq easy-motion-mode " EasyMotion")
      (force-mode-line-update)

      ;; override the local key map
      (setq overriding-local-map easy-motion-mode-map)
      (run-hooks 'easy-motion-mode-hook)

      (add-hook 'mouse-leave-buffer-hook 'easy-motion-done)
      (add-hook 'kbd-macro-termination-hook 'easy-motion-done)))))


(defun easy-motion-mode ( query-char )
  "EasyMotion mode"
  (interactive "cQuery Char:")
  (if (easy-motion-query-char-p query-char)
      (easy-motion-do (make-string 1 query-char))
      (error "Non-printable char")))

(defun easy-motion-move ()
  "move cursor based on user input"
  (interactive)
  (let* ((index (let ((ret (position (aref (this-command-keys) 0)
                                     easy-motion-move-keys)))
                  (if ret ret (length easy-motion-move-keys))))
         (node (nth index (cdr easy-motion-search-tree))))
    (cond
     ;; we do not find key in search tree. This can happen, for
     ;; example, when there is only three selections in screen
     ;; (totally five move-keys), but user press the forth move key
     ((null node)
      (message "No such selection")
      (easy-motion-done))
     ;; this is a branch node, which means there need further
     ;; selection
     ((eq (car node) 'branch)
      (let ((old-tree easy-motion-search-tree))
        ;; we use sub tree in next move, create a new root node
        ;; whose child is the sub tree nodes
        (setq easy-motion-search-tree (cons 'branch (cdr node)))
        (easy-motion-update-overlay-in-search-tree easy-motion-search-tree
                                                   easy-motion-move-keys)
                                            
        ;; this is important, we need remove the subtree first before
        ;; do delete, we set the child nodes to nil
        (setf (cdr node) nil)
        (easy-motion-delete-overlay-in-search-tree old-tree)))
     ;; if the node is leaf node, this is the final one
     ((eq (car node) 'leaf)
      (goto-char (overlay-start (cdr node)))
      (easy-motion-done))
     (t
      (easy-motion-done)
      (error "Unknow tree node")))))
     


(defun easy-motion-done()
  "stop easy motion"
  (interactive)
  (setq easy-motion-mode nil)
  (force-mode-line-update)

  ;; delete background overlay
  (when (not (null easy-motion-background-overlay))
      (delete-overlay easy-motion-background-overlay)
      (setq easy-motion-background-overlay nil))

  ;; delete overlays in search tree
  (easy-motion-delete-overlay-in-search-tree easy-motion-search-tree)
  (setq easy-motion-search-tree nil)
  
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

(defun em-queue-pop (q)
  "dequeue"
  (if (null (em-queue-head q))
      (error "Empty queue"))

  (let ((ret (em-queue-head q)))
    (if (eq ret (em-queue-tail q))
        ;; only one item left
        (progn
          (setf (em-queue-head q) nil)
          (setf (em-queue-tail q) nil))
      ;; multi item left, move forward the head
      (setf (em-queue-head q) (cdr ret)))
    (car ret))) 


