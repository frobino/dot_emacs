;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-java (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_java_code_config.el" ',symbol))
            nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-library-for-java eclim
 
 (require 'eclim)
 (add-hook 'java-mode-hook 'eclim-mode)
 ;; If required to modify the server, this will have to be included
 (require 'eclimd)
 
 (custom-set-variables
  '(eclim-eclipse-dirs '("~/Tools/eclipse"))
  '(eclim-executable "~/Tools/eclipse/eclim"))


 ;; (setq help-at-pt-display-when-idle t)
 ;; (setq help-at-pt-timer-delay 0.1)
 ;; (help-at-pt-set-timer)
 (add-hook 'java-mode-hook (lambda () (help-at-pt-display-when-idle t)))
 (add-hook 'java-mode-hook (lambda () (help-at-pt-timer-delay 0.1)))
 (help-at-pt-set-timer)

 
 )
