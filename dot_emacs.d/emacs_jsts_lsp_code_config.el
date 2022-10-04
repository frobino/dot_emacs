;; This Server supports automatic install. Install this language server with:
;;   M-x lsp-install-server RET ts-ls RET.
;;   npm i -g typescript-language-server; npm i -g typescript

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-jsts (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_jsts_lsp_code_config.el" ',symbol))
            nil))
)

(setq js-indent-level 2)

;; Company mode
(with-library-for-jsts company
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
)

(with-library-for-jsts lsp-mode
  (lsp)
)

(with-library-for-rust lsp-ui
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  :config (setq lsp-ui-sideline-show-hover t
                lsp-ui-sideline-delay 0.5
                lsp-ui-doc-delay 5
                lsp-ui-sideline-ignore-duplicates t
                lsp-ui-doc-position 'bottom
                lsp-ui-doc-alignment 'frame
                lsp-ui-doc-header nil
                lsp-ui-doc-include-signature t
                lsp-ui-doc-use-childframe t)
  ;; :commands lsp-ui-mode
  ;; :bind (:map evil-normal-state-map
  ;;             ("gd" . lsp-ui-peek-find-definitions)
  ;;             ("gr" . lsp-ui-peek-find-references)
  ;;             :map md/leader-map
  ;;             ("Ni" . lsp-ui-imenu))
)

(with-library-for-jsts lsp-treemacs
  (lsp-treemacs-sync-mode 1)
)
