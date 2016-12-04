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

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; 1] Displaying compilation error messages in the echo area
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
 ;; (setq help-at-pt-display-when-idle t)
 ;; (setq help-at-pt-timer-delay 0.1)
 ;; (help-at-pt-set-timer)

 ;; (add-hook 'java-mode-hook (lambda () (setq help-at-pt-display-when-idle t)))
 ;; (add-hook 'java-mode-hook (lambda () (setq help-at-pt-timer-delay 0.1)))
 ;; (add-hook 'java-mode-hook (lambda () (help-at-pt-set-timer)))

 (add-hook 'java-mode-hook (lambda ()
			     (setq help-at-pt-display-when-idle t)
			     (setq help-at-pt-timer-delay 0.1)
			     (help-at-pt-set-timer)
			     )
	   )

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; 2] Configure company mode for autocomplete
 ;;
 ;; TOD: Company starts autocomplete after a few letters are inserted.
 ;; Type M-x company-complete to initiate completion manually. Bind this command to a key combination of your choice.
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (with-library-for-java company
			(require 'company)
			(with-library-for-java company-emacs-eclim
					       (require 'company-emacs-eclim)
					       (company-emacs-eclim-setup)
					       ;;(global-company-mode t)
					       (add-hook 'java-mode-hook #'company-mode)

					       ;; Emacs-eclim completions in company are case sensitive by default.
					       ;; To make completions case insensitive set company-emacs-eclim-ignore-case to t.
					       ;; add-hook 'java-mode-hook (lambda ()
					       ;; 			   (setq company-emacs-eclim-ignore-case t)
					       ;; 			   )
					       ;; 	 )

					       
					       )
			
			)

 ;; TODO: Bind keys
 ;; - Jump to source (F3): eclim-java-find-declaration
 ;; - Showing all references: put your point at the class name or method in question and call the command eclim-java-find-references
 ;; - Refactoring: navigate to the method, class or variable in question and invoke eclim-java-refactor-rename-symbol-at-point
 ;; - Getting help wherever you are: put your pointer on the class or method you want and call eclim-java-show-documentation-for-current-element
 ;; - Showing class inheritance (F4?): class' or an interface's inheritance hiearchy if you invoke eclim-java-hierarchy
 ;;   NOTE: it does not show all available methods of the class...
 ;; - Importing classes & organising imports: import any missing classes and re-organising the imports while it's at it when you call eclim-java-import-organize
 ;; - Correcting problems: nvokingeclim-problems-correct opens up another buffer in which you may preview the different suggestions and before applying them with the suggested fix's number (0-9)
 ;; -
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



