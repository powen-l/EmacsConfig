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

(or (assq 'easy-motion-mode minor-mode-alist)
    (nconc minor-mode-alist
          (list '(easy-motion-mode easy-motion-mode))))

(defvar easy-motion-mode nil
  "Mode variable for EasyMotion minor mode.")
(make-variable-buffer-local 'easy-motion-mode)
(define-key global-map (kbd "C-x SPC") 'easy-motion-mode)  
(define-key global-map (kbd "C-c SPC") 'easy-motion-mode)  


(defvar easy-motion-mode-map 
  (let ((map (make-keymap)))
    (define-key map [t] 'easy-motion-done)
    map)
  "easy motion key map")



(defvar easy-motion-mode-hook nil
  "Funciton(s) to call after start easy motion mode")

(defvar easy-motion-mode-end-hook nil
  "Funciton(s) to call after stop easy motion mode")

(defun easy-motion-done()
  "stop easy motion"
  (interactive)
  (setq easy-motion-mode nil)
  (force-mode-line-update)

  (setq overriding-local-map nil)
  (run-hooks 'easy-motion-mode-end-hook)

  (remove-hook 'mouse-leave-buffer-hook 'easy-motion-done)
  (remove-hook 'kbd-macro-termination-hook 'easy-motion-done)

  )


(defun easy-motion-mode ()
  "EasyMotion mode"
  (interactive)
  (setq easy-motion-mode " EasyMotion")
  (force-mode-line-update)

  (setq overriding-local-map easy-motion-mode-map)
  (run-hooks 'easy-motion-mode-hook)

  (add-hook 'mouse-leave-buffer-hook 'easy-motion-done)
  (add-hook 'kbd-macro-termination-hook 'easy-motion-done)

  )


