;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-vhdl (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_vhdl_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-vhdl 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-library-for-vhdl flycheck
  
  ;; activate flycheck with ghdl backend only if ghdl is in the path
  (when (executable-find "ghdl")
  
    ;; requires ghdl in PATH
    (flycheck-define-checker vhdl-ghdl
    "A VHDL syntax checker using ghdl."
    :command ("ghdl" "-s" "--std=93" "--ieee=synopsys" "-fexplicit" source)
    :error-patterns ((error line-start (file-name) ":" line ":" column ": " (message) line-end))
    :modes (vhdl-mode))
    
    ;; With this technique we do not have flycheck activated in other buffers!
    ;; This is why we use 2 different vhdl_config.el
    (add-hook 'vhdl-mode-hook 'flycheck-mode)
    (add-hook 'vhdl-mode-hook (lambda () (flycheck-select-checker 'vhdl-ghdl)))
    
    ) ;; end when
  
  ) ;; end with-library-for-vhdl
