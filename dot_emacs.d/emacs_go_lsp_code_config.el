;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-go (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_go_lsp_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-go 'lisp-indent-function 1)

;; Company mode
(with-library-for-go company
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
)

(with-library-for-go go-mode
  (defun custom-tab-width-hook ()
    (setq tab-width 2))
  (add-hook 'go-mode-hook #'custom-tab-width-hook)
  (add-hook 'go-mode-hook #'lsp-deferred)
  ;; (add-hook 'go-mode-hook #'tab-width 2)
  ;; (setq tab-width 2)
)

(with-library-for-go lsp-mode
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
)

(with-library-for-go lsp-ui
  ;; (add-hook 'go-mode-hook #'treemacs t)
  ;; (add-hook 'go-mode-hook #'imenu-add-menubar-index)
)

;; (with-library-for-all whitespace
;;   (global-whitespace-mode)
;;   (setq-default tab-width 2)
;;   )
