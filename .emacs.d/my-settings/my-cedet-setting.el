;; -*- coding: utf-8 -*-

(load-file "D:/_SRC_/cedet/common/cedet.el")
(semantic-load-enable-excessive-code-helpers)

(require 'semantic-ia)
;(require 'semantic-gcc)


;; use need to update the specific path
(when (string= (system-name) "DONGWANGDSK01")
  (let ((c++-include-path-list (list "C:/Program Files/Microsoft SDKs/Windows/v6.1/Include"
                                "C:/Program Files/Microsoft SDKs/Windows/v6.1/Include/gl"
                                "C:/Program Files/Microsoft SDKs/Windows/v6.1/VC/Include"
                                "C:/Program Files (x86)/Microsoft Visual Studio 8/VC/include"
                                "C:/Program Files (x86)/Microsoft Visual Studio 8/VC/atlmfc/include"
                                "D:/_SRC_/boost_1_46_1")))
    (mapc (lambda (x) (semantic-add-system-include x 'c++-mode)) c++-include-path-list)))
    

(provide 'my-cedet-setting)
