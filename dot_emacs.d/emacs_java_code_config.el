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

 ;; The followinf if is required to work with emacs executed from eclipse (eclim scenarios 2 and 3)
 ;; WARNING: cl has been deprecated in recent version of emacs...
 ;; https://github.com/senny/emacs-eclim/issues/95
 ;; (if (< emacs-major-version 25) ; this is the test, the "if"
 ;;  (require 'cl)  ; This is the "then"
 ;;  )

 ;; DANGER:
 ;; Since eclim 20161206.908 and yasnippet 20161211.1918 we are obliged to require cl to enable autocomplete.
 ;; This is very strange and it is probably a bug in dependencies (in fact with eclim 201610 everything was working good without cl requirement)
 (require 'cl)

 ;; DANGER:
 ;; The following function would be nice, but if activated some of the autocomplete functionalities get broken.
 ;; For the moment we will keep it COMMENTED and we will accept the delays in autosave.
 ;; (setq eclim-auto-save nil) ;; Avoid delays due to autosave

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
 ;; TODO: Company starts autocomplete after a few letters are inserted.
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
 ;; - ... see http://www.skybert.net/emacs/java/

 ;; Use the followings as reference:
 ;;   (add-hook 'c-mode-hook
 ;;        (lambda() (define-key c-mode-map (kbd "<backtab>") 'company-other-backend))
 ;;        )
 ;;   (add-hook 'c-mode-hook
 ;;        (lambda() (define-key c-mode-map [C-tab] 'moo-complete))
 ;;        )

 ;; TODO: check are the following already implemented?
 ;; (define-key eclim-mode-map (kbd "C-c C-e s") 'eclim-java-method-signature-at-point)
 ;; (define-key eclim-mode-map (kbd "C-c C-e f d") 'eclim-java-find-declaration)
 ;; (define-key eclim-mode-map (kbd "C-c C-e f r") 'eclim-java-find-references)
 ;; (define-key eclim-mode-map (kbd "C-c C-e f t") 'eclim-java-find-type)
 ;; (define-key eclim-mode-map (kbd "C-c C-e f f") 'eclim-java-find-generic)
 ;; (define-key eclim-mode-map (kbd "C-c C-e r") 'eclim-java-refactor-rename-symbol-at-point)
 ;; (define-key eclim-mode-map (kbd "C-c C-e i") 'eclim-java-import-organize)
 ;; (define-key eclim-mode-map (kbd "C-c C-e h") 'eclim-java-hierarchy)
 ;; (define-key eclim-mode-map (kbd "C-c C-e z") 'eclim-java-implement)
 ;; (define-key eclim-mode-map (kbd "C-c C-e d") 'eclim-java-doc-comment)
 ;; (define-key eclim-mode-map (kbd "C-c C-e f s") 'eclim-java-format)
 ;; (define-key eclim-mode-map (kbd "C-c C-e g") 'eclim-java-generate-getter-and-setter)
 ;; (define-key eclim-mode-map (kbd "C-c C-e t") 'eclim-run-junit)

 (add-hook 'java-mode-hook
 	   (lambda() (define-key java-mode-map (kbd "<f3>") 'eclim-java-find-declaration))
 	   )
 (add-hook 'java-mode-hook
 	   (lambda() (define-key java-mode-map (kbd "<f4>") 'eclim-java-hierarchy))
 	   )
 (add-hook 'java-mode-hook
 	   (lambda() (define-key java-mode-map (kbd "<f5>") 'eclim-java-find-references))
 	   )
 (add-hook 'java-mode-hook
 	   (lambda() (define-key java-mode-map (kbd "<f1>") 'eclim-java-show-documentation-for-current-element))
 	   )
 (add-hook 'java-mode-hook
 	   (lambda() (define-key java-mode-map [C-tab] 'eclim-complete))
 	   )

 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



