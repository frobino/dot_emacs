;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-c (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_c_lsp_clangd_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-c 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(with-library-for-c lsp-mode
  ;; `-background-index' requires clangd v8+!
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))
  (add-hook 'c-mode-hook 'lsp)
  (add-hook 'c++-mode-hook 'lsp)
  ;; In case you have subprojects (e.g. soundtouch), use the top one to find the compile_commands.json
  (with-eval-after-load 'projectile
    (setq projectile-project-root-files-top-down-recurring
	  (append '("compile_commands.json"
		    ".cquery")
		  projectile-project-root-files-top-down-recurring)
    )
  )
  ;; Functionalities:
  ;; lsp-find-definition: jumps to definition

  ;; Available C style:
  ;; “gnu”: The default style for GNU projects
  ;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
  ;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
  ;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
  ;; “stroustrup”: What Stroustrup, the author of C++ used in his book
  ;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
  ;; “linux”: What the Linux developers use for kernel development
  ;; “python”: What Python developers use for extension modules
  ;; “java”: The default style for java-mode (see below)
  ;; “user”: When you want to define your own style
  (setq
   c-default-style "linux" ;; set style to "linux"
   c-basic-offset 2
   )

)

;; (with-library-for-c cquery
;;   ;; Setup cquery backend giving the executable path
;;   (setq cquery-executable "/home/osso/Tools/cquery/bin/cquery")
;;   (add-hook 'c-mode-hook 'lsp)
;;   (add-hook 'c++-mode-hook 'lsp)
;;   ;; In case you have subprojects (e.g. soundtouch), use the top one to find the compile_commands.json
;;   (with-eval-after-load 'projectile
;;     (setq projectile-project-root-files-top-down-recurring
;; 	  (append '("compile_commands.json"
;; 		    ".cquery")
;; 		  projectile-project-root-files-top-down-recurring)
;;     )
;;   )
;;   ;; Functionalities:
;;   ;; - find references: M-?
;;   ;; - find definition: M-.
;;   ;; - list callers (who calls a method): M-x cquery-call-hierarchy
;;   ;; (cquery-call-hierarchy nil) ; caller hierarchy
;;   ;; (cquery-call-hierarchy t) ; callee hierarchy
;;   ;; (cquery-inheritance-hierarchy nil) ; base hierarchy
;;   ;; (cquery-inheritance-hierarchy t) ; derived hierarchy
;; )

;; company-lsp is no longer supported since 2021
;;
;; (with-library-for-c company-lsp
;;   (push 'company-lsp company-backends)
;;   (add-hook 'c-mode-hook 'company-mode)
;;   (add-hook 'c++-mode-hook 'company-mode)
;;   ;; disable client-side cache and sorting because the server does a better job when autocompleting
;;   (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)
;; )

(with-library-for-c company
  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'c++-mode-hook 'company-mode)
)

(with-library-for-c lsp-treemacs
  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'c++-mode-hook 'company-mode)
  (lsp-treemacs-sync-mode 1)
)

(with-library-for-c lsp-ui
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  ;; lsp-ui-mode includes lsp flycheck
  (with-library-for-c flycheck
    (add-hook 'lsp-mode-hook 'flycheck-mode)
  )
  ;; Functionalities:
  ;; - fly check
  ;; - outline classes/files: M-x lsp-ui-imenu
)

;; (with-library-for-c treemacs
;;   (add-hook 'c-mode-hook 'treemacs)
;;   (add-hook 'c++-mode-hook 'treemacs)
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; setup GDB

(setq
  ;; use gdb-many-windows by default
  gdb-many-windows t
  ;; Non-nil means display source file containing the main routine at startup
  gdb-show-main t
)

;; NOTES:
;; start with M-x gdb, then write the name of the executable compiled with -g flag
;; Example (without arguments): gdb -i=mi executablename
;; Example (with arguments)   : gdb -i=mi --args executablename arg1 arg2 arg3
