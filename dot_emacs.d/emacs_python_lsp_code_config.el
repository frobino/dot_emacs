;; Requires:
;; - LSP: pip install python-language-server[all]
;; - DAP: pip install debugpy

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-python (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_python_lsp_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-python 'lisp-indent-function 1)

(with-library-for-python lsp-mode
  ;; :hook
  ;; ((python-mode . lsp)
  ;;  (lsp-mode . lsp-enable-which-key-integration))
  (add-hook 'python-mode-hook 'lsp)
  ;; :config
  (setq lsp-idle-delay 0.5
        lsp-enable-symbol-highlighting t
        lsp-enable-snippet nil  ;; Not supported by company capf, which is the recommended company backend
        lsp-pyls-plugins-flake8-enabled t)
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)

     ;; Disable these as they're duplicated by flake8
     ("pyls.plugins.pycodestyle.enabled" nil t)
     ("pyls.plugins.mccabe.enabled" nil t)
     ("pyls.plugins.pyflakes.enabled" nil t)))
  ;; :bind (:map evil-normal-state-map
  ;;             ("gh" . lsp-describe-thing-at-point)
  ;;             :map md/leader-map
  ;;             ("Ff" . lsp-format-buffer)
  ;;             ("FR" . lsp-rename))
  )

(with-library-for-python lsp-ui
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

(with-library-for-python lsp-treemacs
  (lsp-treemacs-sync-mode 1)
  )

;; (with-library-for-python pyvenv
;;   :demand t
;;   :config
;;   (setq pyvenv-workon "emacs")  ; Default venv
;;   (pyvenv-tracking-mode 1))  ; Automatically use pyvenv-workon via dir-locals

;; setup PDB (run M-x pdb)

(setq
  ;; use gdb-many-windows by default
  gdb-many-windows t
  ;; Non-nil means display source file containing the main routine at startup
  gdb-show-main t
)

;; setup DAP (run M-x dap-debug)

(with-library-for-python dap-mode
  ;; Enabling only some features
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  (setq dap-python-debugger 'debugpy)
  ;; (dap-python-debugger 'debugpy)
  (require 'dap-python)
  (dap-register-debug-template "My App"
  (list :type "python"
        :args "-a -b -c -f <filename>"
        :cwd nil
        :env '(("DEBUG" . "1"))
        :target-module (expand-file-name "~/Projects/ProjectName/executable")
        :request "launch"
        :name "My App"))
)
