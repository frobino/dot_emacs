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
;;
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

(with-library-for-c company
  (add-hook 'after-init-hook 'global-company-mode)
  ;; NOTE: the following "delete" is not necessary if we target the CEDET semantic backend.
  ;; If we want to use the clang (or others backend) we have to delete company-semantic,
  ;; otherwise company-complete will use company-semantic instead of company-clang,
  ;; because it has higher precedence in company-backends.  
  (delete 'company-semantic company-backends)
  (add-hook 'c-mode-hook
	    (lambda() (define-key c-mode-map (kbd "<backtab>") 'company-complete))
	    )
  (add-hook 'c++-mode-hook
	    (lambda() (define-key c++-mode-map (kbd "<backtab>") 'company-complete))
	    )
  )

;; NOTES about company:
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; function-args: showing an inline arguments hint for the C/C++ function at point.

(with-library-for-c function-args
  (fa-config-default)
  (add-hook 'c-mode-hook
	    (lambda() (define-key c-mode-map [C-tab] 'moo-complete))
	    )
  (add-hook 'c++-mode-hook
	    (lambda() (define-key c++-mode-map [C-tab] 'moo-complete))
	    )
  ;;(define-key c-mode-map (kbd "C-c C-c") 'moo-complete)
  ;;(eval-after-load 'c-mode '(define-key c-mode-map [tab] 'outline-cycle))
  ;;(define-key c-mode-map  [C-tab] 'moo-complete)
  ;;(define-key c++-mode-map  [C-tab] 'moo-complete)
  )

;; Alternative way (without check): 
;;
;; (with-library-for-c function-args
;;   (fa-config-default)
;;   (define-key c-mode-map  [(control tab)] 'moo-complete)
;;   (define-key c++-mode-map  [(control tab)] 'moo-complete)
;;   (define-key c-mode-map (kbd "M-o")  'fa-show)
;;   (define-key c++-mode-map (kbd "M-o")  'fa-show))

;; NOTES about function-args:
;;
;; fa-jump, moo-complete, moo-jump-local are AMAZING functions. Find good key mapping for
;; them and remember to use them

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; hs-minor-mode: fold and hide blocks

(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)

;; NOTES about hs-minor-mode:
;;
;; Main shortcuts:
;; C-c @ C-h: hide a block
;; C-c @ C-s: show a block
;; C-c @ C-M-s: show all blocks
;; C-c @ C-l: hide level

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; sr_speedbar: speedbar in console (not in frame)

(with-library-for-c sr-speedbar
  (setq speedbar-show-unknown-files t)
  )

;; NOTES about sr_speedbar
;;
;; Main shortcuts:
;; M-x sr-speedbar-toggle
;; SPC open/close children of a node
;; RET to open

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; company-c-header: auto completion for headers

(with-library-for-c company-c-headers
  (add-to-list 'company-backends 'company-c-headers)
  )

;; NOTES: about company-c-header
;;
;; Add library path with the following:
;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; yasnippet: function templates

(with-library-for-c yasnippet
  (add-hook 'c-mode-hook 'yas-global-mode)
  (add-hook 'c++-mode-hook 'yas-global-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
