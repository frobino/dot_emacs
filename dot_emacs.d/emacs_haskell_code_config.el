;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-haskell (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_haskell_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-c 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; haskell indent mode
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(with-library-for-haskell haskell
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
