;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-all (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_all_config.el" ',symbol))
            nil)))
(put 'with-library-for-all 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-library-for-all undo-tree
  (undo-tree-mode)
  )

;; Add golden ratio mode down here?


