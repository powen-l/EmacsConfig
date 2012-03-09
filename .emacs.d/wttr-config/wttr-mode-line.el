;; -*- coding: utf-8 -*-

(eval-when-compile
  (require 'cl))

(defun wttr/mode-line:current-height ()
  "Return the mode line height of the current window.
NOTE: this function should be used after you apply any font settings.
Otherwise, the return value may not be the corrent value for current fontset."
  (- (elt (window-pixel-edges) 3)
     (elt (window-inside-pixel-edges) 3)))

(defun wttr/mode-line:data-generator-left-triangle (height width)
  "Generator for the data section of the XPM format image.
This function is used to generate the left triangle style.
It return a alist ((data \"data-string\") (width <num>) (height <num))."
  (let* ((min-triagle-width (+ (/ height 2) (% height 2)))
         (final-width (max min-triagle-width width))
         (line-format "\"%s%s\"")
         (top-part
          (loop for offset from 1 to (/ height 2)
                collect (format line-format
                                (make-string offset ?.)
                                (make-string (- final-width offset) ? ))))
         (data (mapconcat #'identity
                          (append top-part
                                  (if (equal (% height 2) 1)
                                      (list (format line-format
                                                    (make-string min-triagle-width ?.)
                                                    (make-string (- final-width min-triagle-width) ? ))))
                                  (reverse top-part))
                          ",\n")))
    (list (list 'data data) (list 'width final-width) (list 'height height))))


(defun wttr/create-bicolor-xpm (height width fg-color bg-color data-generator)
  "Create the xpm image for showing based on the width and height.
The actual result will based on the return value of data-generator,
which shows the real width and height of the final data.

The input DATA-GENERATOR is a funciton object, will be called as:
(DATA-GENERATOR height width)

It should return an alist as below:
((data \"data-string\") (height <num) (width <num>))

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

;

;(insert (propertize " "
;                    'display
;                    (wttr/create-bicolor-xpm 22
;                                             15
;                                             "#00AA00"
;                                             "#BB0000"
;                                             #'wttr/mode-line:data-generator-left-triangle)))

             


;(defun arrow-right-xpm (color1 color2)
;  "Return an XPM right arrow string representing."
;  (format "/* XPM */
;static char * arrow_right[] = {
;\"12 22 2 1\",
;\".	c %s\",
;\" 	c %s\",
;\".           \",
;\"..          \",
;\"...         \",
;\"....        \",
;\".....       \",
;\"......      \",
;\".......     \",
;\"........    \",
;\".........   \",
;\"..........  \",
;\"........... \",
;\"............\",
;\"........... \",
;\"..........  \",
;\".........   \",
;\"........    \",
;\".......     \",
;\"......      \",
;\".....       \",
;\"....        \",
;\"...         \",
;\"..          \",
;\".           \"};"  color1 color2))
;
;(defun arrow-left-xpm (color1 color2)
;  "Return an XPM right arrow string representing."
;  (format "/* XPM */
;static char * arrow_right[] = {
;\"12 22 2 1\",
;\".	c %s\",
;\" 	c %s\",
;\"           .\",
;\"          ..\",
;\"         ...\",
;\"        ....\",
;\"       .....\",
;\"      ......\",
;\"     .......\",
;\"    ........\",
;\"   .........\",
;\"  ..........\",
;\" ...........\",
;\"............\",
;\" ...........\",
;\"   .........\",
;\"    ........\",
;\"     .......\",
;\"      ......\",
;\"       .....\",
;\"        ....\",
;\"         ...\",
;\"          ..\",
;\"           .\"};"  color2 color1))
;
;
;(setq color1 "#00AA00")
;(setq color2 "#AAAAAA")
;
;(setq arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
;(setq arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
;(setq arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
;(setq arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))
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
(setq-default mode-line-format
      '( "%e"
         "-"
         ("[" (:eval (format "%s" buffer-file-coding-system)) ":")   ;mode-line-mule-info, use more readable format
         ;mode-line-client, remove
         ("" mode-line-modified "]") ; change format to be together with encoding
         ;mode-line-remote, remove
         ;mode-line-frame-identification, remove
         "["
         mode-line-buffer-identification
         "]"
         mode-line-position
         (vc-mode vc-mode)
         mode-line-modes
         ;("" viper-mode-string)    ;global-mode-string contains it
         global-mode-string
         ;("[" default-directory "]")
         "-%-" ) )


(provide 'wttr-mode-line)
