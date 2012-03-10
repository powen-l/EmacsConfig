;; -*- coding: utf-8 -*-

(eval-when-compile
  (require 'cl))

(defun wttr/mode-line:current-height ()
  "Return the mode line height of the current window.
NOTE: this function should be used after you apply any font settings.
Otherwise, the return value may not be the corrent value for current fontset."
  (- (elt (window-pixel-edges) 3)
     (elt (window-inside-pixel-edges) 3)))

(defun wttr/defun-bicolor-face (face fg-color bg-color)
    (make-face face)
    (set-face-attribute face nil
                        :foreground fg-color
                        :background bg-color))

(defun wttr/defun-bicolor-transition-face (face bicolor-face-from bicolor-face-to)
  (wttr/defun-bicolor-face face
                           (face-attribute bicolor-face-from :background)
                           (face-attribute bicolor-face-to :background)))
  
    

(defun wttr/bicolor-face-attribute (face)
  (list
   (face-attribute face :foreground)
   (face-attribute face :background)))

(defun wttr/mode-line:data-generator-left-triangle (height width)
  "Generator for the data section of the XPM format image.
This function is used to generate the left triangle style.
It return a alist ((data \"data-string\") (width <num>) (height <num))."
  (let* ((min-triagle-width (+ (/ height 2) (% height 2)))
         (final-width (max min-triagle-width width))
         (make-line #'(lambda (offset)
                        (format "\"%s%s\""
                                (make-string offset ?.)
                                (make-string (- final-width offset) ? ))))
         (top-part
          (loop for offset from 1 to (/ height 2)
                collect (funcall make-line offset)))
         (data (mapconcat #'identity
                          (append top-part
                                  (if (equal (% height 2) 1)
                                      (list (funcall make-line min-triagle-width)))
                                  (reverse top-part))
                          ",\n")))
    (list (list 'data data) (list 'width final-width) (list 'height height))))


(defun wttr/create-bicolor-xpm (height width fg-color bg-color data-generator)
  "Create the xpm image for showing based on the width and height.
The actual result will based on the return value of data-generator,
which shows the real width and height of the final data.

The input DATA-GENERATOR is a funciton object, will be called as:
\(DATA-GENERATOR height width\)

It should return an alist as below:
\((data \"data-string\") (height <num) (width <num>)\)

The data is the <Pixels> part of a XPM format image.  You can refer
here : http://en.wikipedia.org/wiki/X_PixMap. The width and height
gives the real image created by this generator, which will filled
into <Values> part of the XPM.

All the data must only contains dot(.) and Space( ), so that the dot
will be filled with FG-COLOR and Space will be filled with BG-COLOR."
  (let ((base-xpm-format "/* XPM */
static char * XPM_IMAGE[] = {
/* <Values> */
/* <width/cols> <height/rows> <colors> <char on pixel>*/
\"%d %d 2 1\",
/* <Colors> */
\". c %s\",
\"  c %s\",
/* <Pixels> */
%s}\;")
        (generated-data (funcall data-generator height width)))
     (create-image (format base-xpm-format
                           (second (assoc 'width generated-data))
                           (second (assoc 'height generated-data))
                           fg-color
                           bg-color
                           (second (assoc 'data generated-data)))
                    'xpm t :ascent 'center)))

(defun wttr/create-bicolor-xpm-from-face (height width bicolor-face data-generator)
  (apply #'wttr/create-bicolor-xpm
         (append 
          (list height width)
          (wttr/bicolor-face-attribute bicolor-face)
          (list data-generator))))


(defun wttr/mode-line:create-left-triangle-xpm (bicolor-face &optional width)
  "This function will create the left triangle XPM based on the
current height of the mode line, with FG-COLOR to be triangle color,
and BG-COLOR to be the background color"
  (let* ((height (wttr/mode-line:current-height))
         (width (or width height )))
    (wttr/create-bicolor-xpm-from-face height
                                       width
                                       bicolor-face
                                       #'wttr/mode-line:data-generator-left-triangle)))



(defun wttr/mode-line:decorate-string-face (mode-line-var bicolor-face)
  (let ((decorate-into (lambda (var)
                         (cond
                          ((stringp var)
                           ;; it should be better to add "%" check
                           ;; actually I need more better way to know which kind of
                           ;; string need to be decorated.
                           ;(if (string-match-p "%" var)
                           ;    (propertize var 'face bicolor-face)
                           ;  var))
                           (propertize var 'face bicolor-face))
                          ((arrayp var)
                           (map 'array decorate-into var))
                          ((listp var)
                           (mapcar decorate-into var))
                          (t
                           var)))))
    (funcall decorate-into mode-line-var)))

    
(wttr/defun-bicolor-face 'mode-line-face/encoding-writable-modified "#000000" "#DDDDDD")
(wttr/defun-bicolor-face 'mode-line-face/buffer-name "#000000" "#888888")
(wttr/defun-bicolor-face 'mode-line-face/line-position "#000000" "#444444")
(wttr/defun-bicolor-transition-face 'mode-line-face/transition1
                                    'mode-line-face/encoding-writable-modified
                                    'mode-line-face/buffer-name)
(wttr/defun-bicolor-transition-face 'mode-line-face/transition2
                                    'mode-line-face/buffer-name
                                    'mode-line-face/line-position)
(wttr/defun-bicolor-transition-face 'mode-line-face/transition3
                                    'mode-line-face/line-position
                                    'mode-line)

(defun wttr/mode-line:create-triangle-seperator (face)
  (propertize " "
              'display
              (wttr/mode-line:create-left-triangle-xpm face)))

(setq-default mode-line-format
              (list
               '(:eval (propertize (concat "%e"
                                           "-"
                                           ;mode-line-mule-info, use more readable format
                                           (format "%s" buffer-file-coding-system)
                                           ":")
                                   'face 'mode-line-face/encoding-writable-modified))
               (wttr/mode-line:decorate-string-face mode-line-modified
                                                    'mode-line-face/encoding-writable-modified)
               (wttr/mode-line:create-triangle-seperator 'mode-line-face/transition1)
               ;mode-line-remote, remove
               ;mode-line-frame-identification, remove
               (wttr/mode-line:decorate-string-face mode-line-buffer-identification
                                                    'mode-line-face/buffer-name)
               (wttr/mode-line:create-triangle-seperator 'mode-line-face/transition2)
               (wttr/mode-line:decorate-string-face mode-line-position
                                                    'mode-line-face/line-position)
               (wttr/mode-line:create-triangle-seperator 'mode-line-face/transition3)
               '(vc-mode vc-mode)
               mode-line-modes
               ;("" viper-mode-string)    ;global-mode-string contains it
               global-mode-string
               ;("[" default-directory "]")
               "-%-" ))



;(setq color1 "#00AA00")
;(setq color2 "#AAAAAA")
;
;(setq-default mode-line-format
; (list  '(:eval (concat (propertize " %b " 'face 'mode-line-color-1)
;                        (propertize " " 'display arrow-right-1)))
;        '(:eval (concat (propertize " %m " 'face 'mode-line-color-2)
;                        (propertize " " 'display arrow-right-2)))
;
;        ;; Justify right by filling with spaces to right fringe - 16
;        ;; (16 should be computed rahter than hardcoded)
;        '(:eval (propertize " " 'display '((space :align-to (- right-fringe 17)))))
;
;        '(:eval (concat (propertize " " 'display arrow-left-2)
;                        (propertize " %p " 'face 'mode-line-color-2)))
;        '(:eval (concat (propertize " " 'display arrow-left-1)
;                        (propertize "%4l:%2c  " 'face 'mode-line-color-1)))
;)) 
;
;(make-face 'mode-line-color-1)
;(set-face-attribute 'mode-line-color-1 nil
;                    :foreground "#0f0f0f"
;                    :background color1)
;
;(make-face 'mode-line-color-2)
;(set-face-attribute 'mode-line-color-2 nil
;                    :foreground "#0f0f0f"
;                    :background color2)
;
;(set-face-attribute 'mode-line nil
;                    :foreground "#0f0f0f"
;                    :background "#000000"
;                    :box nil)
;(set-face-attribute 'mode-line-inactive nil
;                    :foreground "#0f0f0f"
;                    :background "#000000")

;(setq global-mode-string (append global-mode-string  '("  [" default-directory "]") ))
;(setq-default mode-line-format
;      '( "%e"
;         "-"
;         ("[" (:eval (format (propertize "%s" 'face face-111) buffer-file-coding-system)) ":")   ;mode-line-mule-info, use more readable format
;         ;mode-line-client, remove
;         ("" mode-line-modified "]") ; change format to be together with encoding
;         ;mode-line-remote, remove
;         ;mode-line-frame-identification, remove
;         "["
;         mode-line-buffer-identification
;         "]"
;         mode-line-position
;         (vc-mode vc-mode)
;         mode-line-modes
;         ;("" viper-mode-string)    ;global-mode-string contains it
;         global-mode-string
;         ;("[" default-directory "]")
;         "-%-" ) )


(provide 'wttr-mode-line)
