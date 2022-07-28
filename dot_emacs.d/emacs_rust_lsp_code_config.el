;; Requres rls language server installed: https://github.com/rust-lang/rls

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-rust (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_rust_lsp_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-rust 'lisp-indent-function 1)

;; Company mode
(with-library-for-rust company
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
)

(with-library-for-rust lsp-mode
  ;; TODO: for some reason the lsp is not hooked, must be started manually
  ;; :hook
  ;; ((python-mode . lsp)
  ;; (add-hook 'python-mode-hook 'lsp)
  (add-hook 'rust-mode-hook #'lsp)
  ;; :config
  (setq lsp-rust-server 'rls)
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

(with-library-for-rust lsp-treemacs
  (lsp-treemacs-sync-mode 1)
  )

;; debug using a similar techique to cpp
(with-library-for-rust dap-mode
  ;; Enabling only some features
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  (setq dap-lldb-debug-program '("/usr/bin/lldb-vscode-13"))
  (require 'dap-lldb)
  (dap-register-debug-template
   "Rust::LLDB Run Configuration"
   (list :type "lldb-vscode"
         :request "launch"
         :name "LLDB::Run"
	 :gdbpath "rust-lldb"
	 :program "${workspaceFolder}/target/debug/hello_cargo"
	 :cwd "${workspaceFolder}"
	 :target "${workspaceFolder}/target/debug/hello_cargo"
	 ))
)
