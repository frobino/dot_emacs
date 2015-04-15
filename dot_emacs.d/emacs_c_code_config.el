;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-c (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_c_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-c 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Autocompletion with CEDET and semantics mode
(with-library-for-c semantic
  (add-hook 'c-mode-hook 'global-semanticdb-minor-mode)
  (add-hook 'c++-mode-hook 'global-semanticdb-minor-mode)
  (add-hook 'c-mode-hook 'global-semantic-idle-completions-mode)
  (add-hook 'c++-mode-hook 'global-semantic-idle-completions-mode)
  (add-hook 'c-mode-hook 'semantic-mode)
  (add-hook 'c++-mode-hook 'semantic-mode))

;; Alternative way (without check): 
;; (require 'semantic)
;; (global-semanticdb-minor-mode 1)
;; (global-semantic-idle-completions-mode 1)
;; (semantic-mode 1))

;; NOTES about semantic:
;;
;; You can view the list of include paths in semantic-dependency-system-include-path.
;; To add more include paths, use the function semantic-add-system-include like this:
;;
;; (semantic-add-system-include "/usr/include/boost" 'c++-mode)
;; (semantic-add-system-include "~/linux/kernel")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Autocompletion with company mode using semantics as backend
;; (require 'cc-mode)
;; (require 'semantic)
;; (require 'company)
;; (global-company-mode 1)
;; (company-semantic 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NOTE: the following does not work!
;; But if i use the require technique it does not shoot out error...

;; Function-args: showing an inline arguments hint for the C/C++ function at point.

;; (with-library-for-c function-args
;;   (fa-config-default)
;;   (define-key c-mode-map  [(control tab)] 'moo-complete)
;;   (define-key c++-mode-map  [(control tab)] 'moo-complete)
;;   (define-key c-mode-map (kbd "M-o")  'fa-show)
;;   (define-key c++-mode-map (kbd "M-o")  'fa-show))

(with-library-for-c function-args
  (fa-config-default)
  (define-key map  [(tab)] 'moo-complete)
  ;;(eval-after-load 'c-mode '(define-key c-mode-map [tab] 'outline-cycle))
  ;;(define-key c-mode-map  [C-tab] 'moo-complete)
  ;;(define-key c++-mode-map  [C-tab] 'moo-complete)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(with-library-for-c yasnippet)
