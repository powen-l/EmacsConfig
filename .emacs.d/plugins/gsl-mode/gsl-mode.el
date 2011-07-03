;;; gsl-mode.el --- a script viewer and editor for gomez script

;; Copyright (C) 2011 Free Software Foundation, Inc.

;; Author:   winterTTr <winterTTr@gmail.com>
;; Keywords: gomez, gslv2

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
;; gsl-mode is a major mode for view and edit gomez script, which with
;; the suffix as gsl


(require 'xml)
(require 'json)


(defvar gsl-mode-hook nil
  "*List of the functions called when enter gsl-mode")

(defvar gsl-mode-map nil
  "key map for gsl-mode")

(if gsl-mode-map
    nil
  (setq gsl-mode-map (make-sparse-keymap))
  ;;(define-key gsl-mode-map key command)
  )

;;;; gsl specific const
(defconst gsl-header-configuration-name "http://www.gomez.com/headers"
  "the configuration with `name' attribute to this is a header configuration")


;;;; gsl-mode specific vairable
(defvar gsl-summary-region nil
  "The marker for summary region")

;;;; summary format settings
(defconst gsl-summary-format-config
  '(:flag "C" :align 50 :delimiter "=> ")
  "format for configuration")

(defconst gsl-summary-format-header
  '(:flag "H" :align 20 :delimiter "=> ")
  "format  for header")

(defconst gsl-summary-format-property
  '(:flag "P" :align 20 :delimiter "=> ")
  "format for header")

(defconst gsl-summary-step-base 1
  "from which the step is start")

(defconst gsl-summary-action-base 1
  "from which the action is start")

(defun gsl-mode ()
  "major mode for edit gsl file"
  (interactive)
  (kill-all-local-variables)
  (text-mode)

  ;; setup major mode
  (setq major-mode 'gsl-mode)
  (setq mode-name "GSLv2")
  (use-local-map gsl-mode-map)

  ;; create local variable
  (make-local-variable 'gsl-summary-region)

  (gsl-summary-from-buffer)
  (run-hooks 'gsl-mode-hook) )


(defun gsl-summary-from-buffer ()
  "we analyze the buffer to generate information"
  (interactive)
  (widen)
  ; delete old summary 
  (if (not (null gsl-summary-region))
    (delete-region
     (car gsl-summary-region)
     (cdr gsl-summary-region)) )
  ; make new summary
  (goto-char (point-max))
  (let* ( (region-begin (point-marker) )
         (txn (car (xml-parse-region (point-min) (point-max)))) )
    (if (null txn)
        (error "not a valid xml format"))
    (gsl-summary-generate-content txn)
    ;; after update buffer remember the update concent region
    (goto-char (point-max))
    (setq gsl-summary-region (cons region-begin  (point-marker) ) )
    (narrow-to-region (car gsl-summary-region)
                      (cdr gsl-summary-region))
    ))


(defun gsl-summary-generate-content ( txn )
  "insert the summary content based on the xml txn node"
  ; insert txn part : property , configuration, header
  (insert "[Transaction]\n")
  ; insert properties
  (gsl-summary-insert-properties txn)
  ; insert configuration of transaction
  (gsl-summary-insert-configurations txn)
  (insert "\n")
  ; insert step of transaction
  (let ((step-index gsl-summary-step-base))
    (dolist (step (xml-get-children txn 'PageRequest))
      (insert (format "  [Step%2d]\n"
                      step-index))
      (gsl-summary-insert-properties step 2 '(pre_script post_script) )
      (gsl-summary-insert-configurations step 2)
      (gsl-summary-insert-json-script step 2)
      (insert "\n")))
  )

(defun gsl-summary-insert-json-script ( step-node step-indent )
  "insert the action in current step-node"
  (let ( (pre-script (xml-get-attribute-or-nil step-node 'pre_script))
         (post-script (xml-get-attribute-or-nil step-node 'post_script)))
    (when (not (null pre-script))
      (insert (substring pre-script 0 5))
      (insert "\n") )
    (if (not (null post-script))
      (let ( (action-base gsl-summary-action-base)
             (action-indent (+ step-indent 2)) )
        (dolist (action (gsl-summary-b64-decode post-script))
          (gsl-summary-insert-action action action-indent)
          (incf action-base)))) ) )

(defun gsl-summary-insert-action (action action-indent)
  "insert specific action content based on the :type"
  (let ( (type (plist-get action :type))
         (action-indent-str (make-string action-indent ?\ )) )
    (insert (format "%s[Action%2d:%s]\n"
                    action-indent-str
                    action-base
                    type) )
    ;(insert "\n")
    ) )

(defun gsl-summary-b64-decode( b64-script )
  "decode base64-encoded script section"
  (let ((json-object-type 'plist)
        (json-array-type 'list))
    (json-read-from-string (base64-decode-string b64-script))))

(defun gsl-summary-gen-fmt ( fmt-plist )
  "generate the format based on the paramerter fmt-plist"
  (concat (plist-get fmt-plist :flag)
          "::"
          "%-" (number-to-string (plist-get fmt-plist :align)) "s"
          (plist-get fmt-plist :delimiter)
          "[%s]"))

(defun gsl-summary-insert-properties ( node &optional indent-length exclude-items )
  "insert the property of the node based on `gsl-summary-format-property'"
  (let ((fmt (gsl-summary-gen-fmt gsl-summary-format-property)))
    (if (not (null indent-length))
        (setq fmt (concat (make-string indent-length ?\ ) fmt)))
    ; we do not output such 'pre_script property as normal
    (dolist (attrib (remove-if (lambda (x) (memq (car x) exclude-items))
                               (xml-node-attributes node)))
      (insert (format fmt
                      (symbol-name (car attrib))
                      (cdr attrib)))
      (insert "\n"))))


(defun gsl-summary-insert-configurations (node &optional indent-length )
  "insert configuration of current node"
  (dolist (config (xml-get-children node 'Configuration))
    (let (fmt)
      ; distinguish the header config and txn config
      (if (string= (xml-get-attribute config 'name)
                   gsl-header-configuration-name)
          (setq fmt (gsl-summary-gen-fmt gsl-summary-format-header))
        (setq fmt (gsl-summary-gen-fmt gsl-summary-format-config)))
      ; process indent
      (if (not (null indent-length))
          (setq fmt (concat (make-string indent-length ?\ ) fmt)))
        ; we need to skip the text-node
      (dolist (param
               (remove-if-not (lambda (x) (listp x))
                              (xml-node-children config)))
        (insert (format fmt
                        (xml-get-attribute param 'name)
                        (xml-get-attribute param 'value)))
        (insert "\n")))))



;(provide 'gsl-mode)
