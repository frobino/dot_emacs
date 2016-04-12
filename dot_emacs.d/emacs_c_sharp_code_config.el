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

;; Check that the csharp major mode is installed in emacs
;;
;; Csharp-mode includes the following features by default:
;; - font-lock and indent of C# syntax including:
;; - automagic code-doc generation when you type three slashes.
;; - intelligent insertion of matched pairs of curly braces.
;; - imenu indexing of C# source, for easy menu-based navigation.
;; - compilation-mode support for msbuild, devenv and xbuild.
;;
(with-library-for-c csharp-mode
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; iMenu parser creating index of contents of C# buffer.
;; Can be integrated in speedbar.
;;
;; For big projects can crash/break, so it can be useful to include a TAGS backend.
;;

;; TBD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Flymake (FlymakeCsharp) , FlymakeCursor, RFringe
;;
;; Flymake (embedded in emacs): live compilation of code (through csc.exe and fxcopcmd.exe for C#)
;; FlymakeCursor: automatically displays the flymake error for the current line in the minibuffer.
;; RFringe: displays buffer-relative locations in the fringe (column).

;; TBD, or maybe embedded in Omnisharp?

;; (with-library-for-c flymake
;;   (add-hook 'csharp-mode-hook 'flymake-mode)
;;   )
;; 
;; (with-library-for-c rfringe
;;   (add-hook 'csharp-mode-hook 'fringe-mode)
;;   )
;; 
;; (with-library-for-c flymake-cursor
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Compilation with compilation-error-regexp-alist-alist
;;
;; The default build command is ‘nmake’ but you can specify it explicitly in each buffer with in-code comments:
;; // compile: c:\.NET3.5\csc.exe /t:module /r:MyAssembly.dll file.cs
;; You can replace that compile command with whatever you like. For example:
;; // compile: msbuild.exe /p:Configuration:Release

;; TBD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HideShow, YASnippet, Linum

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Omnisharp
;; Provides smart completion, refactoring, finding implementations/usages, eldoc integration and more
;; Requires omnisharp-server (https://github.com/OmniSharp/omnisharp-server) to be installed and run in the background.
;; E.g. OmniSharp.exe -s path/to/solution
;; Requires curl in the path.
;; Follow the desccription in http://www.slideshare.net/DanielKOBINA/omnisharp-up-and-running to configure.

;; Company-mode autocompletion configuration
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-omnisharp))

;; Additonal configurations for omnisharp-mode 
(with-library-for-c omnisharp
  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  ;; Curl MUST be installed to run omnisharp server.
  (when mswindows-p
    (setq omnisharp--curl-executable-path "E:/Program Files/curl/curl.exe")
    )
  ;; The omnisharp-server MUST be installed to use omnisharp-mode (https://github.com/OmniSharp/omnisharp-server)
  (when mswindows-p
    (setq omnisharp-server-executable-path "E:/Program Files/omnisharp-server/OmniSharp/bin/Debug/OmniSharp.exe")
    )
  ;; (defvar omnisharp-server-executable-path "E:/Program Files/omnisharp-server/OmniSharp/bin/Debug/OmniSharp.exe")
  ;;'(omnisharp-server-executable-path "E:/Program Files/omnisharp-server/OmniSharp/bin/Debug/OmniSharp.exe")

  ;; Remove tabs from indentation
  (setq-default indent-tabs-mode nil)

  ;; Activate company mode for company-mode autocompletion
  ;; NOTE: Pressing F1 with a candidate selected in the the company-mode popup shows a buffer with documentation.
  (add-hook 'csharp-mode-hook 'global-company-mode)
  ;; yas minor mode required for autocomplete of an object methods
  (add-hook 'csharp-mode-hook 'yas-minor-mode)
  
  ;; The following is adapted from https://github.com/OmniSharp/omnisharp-emacs/blob/master/example-config-for-evil-mode.el
  (define-key omnisharp-mode-map (kbd "<backtab>") 'omnisharp-auto-complete)
  (define-key omnisharp-mode-map (kbd "<f12>") 'omnisharp-go-to-definition)
  (define-key omnisharp-mode-map (kbd "<f7>") 'omnisharp-build-in-emacs)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g u") 'omnisharp-find-usages)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g I") 'omnisharp-find-implementations) ; g i is taken
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g o") 'omnisharp-go-to-definition)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g r") 'omnisharp-run-code-action-refactoring)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g f") 'omnisharp-fix-code-issue-at-point)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g F") 'omnisharp-fix-usings)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "g R") 'omnisharp-rename)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", i") 'omnisharp-current-type-information)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", I") 'omnisharp-current-type-documentation)
  ;;    (define-key 'insert omnisharp-mode-map (kbd ".") 'omnisharp-add-dot-and-auto-complete)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", n t") 'omnisharp-navigate-to-current-file-member)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", n s") 'omnisharp-navigate-to-solution-member)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", n f") 'omnisharp-navigate-to-solution-file-then-file-member)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", n F") 'omnisharp-navigate-to-solution-file)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ", n r") 'omnisharp-navigate-to-region)
  ;;    (define-key 'normal omnisharp-mode-map (kbd "<f12>") 'omnisharp-show-last-auto-complete-result)
  ;;    (define-key 'insert omnisharp-mode-map (kbd "<f12>") 'omnisharp-show-last-auto-complete-result)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ",.") 'omnisharp-show-overloads-at-point)
  ;;    (define-key 'normal omnisharp-mode-map (kbd ",rl") 'recompile)
  ;;  
  ;;    (define-key 'normal omnisharp-mode-map (kbd ",rt")
  ;;      (lambda() (interactive) (omnisharp-unit-test "single")))
  ;;  
  ;;    (define-key 'normal omnisharp-mode-map
  ;;      (kbd ",rf")
  ;;      (lambda() (interactive) (omnisharp-unit-test "fixture")))
  ;;  
  ;;    (define-key 'normal omnisharp-mode-map
  ;;      (kbd ",ra")
  ;;      (lambda() (interactive) (omnisharp-unit-test "all")))
  ;;  
  ;;    ;; Speed up auto-complete on mono drastically. This comes with the
  ;;    ;; downside that documentation is impossible to fetch.
  ;;    (setq omnisharp-auto-complete-want-documentation nil)

  ;; Activate imenu support so that sr-speedbar recognizes class and members
  (setq-default omnisharp-imenu-support t)
  ;;

  ;; Working windows omnisharp syntax checker for flycheck
  ;; https://gist.github.com/jordonbiondo/10656469
  ;; (flycheck-define-checker omnisharp
  ;;   "Flycheck checker for omnisharp"
  ;;   :command ("curl" 
  ;;             "--silent" "-H"
  ;;             "Content-type: application/json"
  ;;             "--data-binary" 
  ;;             (eval (concat "@" (omnisharp--write-json-params-to-tmp-file
  ;;                                omnisharp--windows-curl-tmp-file-path
  ;;                                (json-encode (omnisharp--get-common-params))))) ;; do the work here, and get the path
  ;;             "http://localhost:2000/syntaxerrors")
  ;;   :error-parser omnisharp--flycheck-error-parser-raw-json
  ;;   :modes csharp-mode)
  ;; (defun omnisharp--write-json-params-to-tmp-file
  ;;     (target-path stuff-to-write-to-file)
  ;;   "Deletes the file when done."
  ;;   (with-temp-file target-path
  ;;     (insert stuff-to-write-to-file)
  ;;     target-path)) ;; return the target path
  ;; ;; if syntax checker executable is not in PATH (http://www.flycheck.org/manual/latest/Configuring-checkers.html):
  ;; (setq flycheck-omnisharp-executable "C:/Program Files (x86)/MSBuild/12.0/Bin/csc.exe")
  ;; (setq flycheck-omnisharp-executable "C:/Windows/Microsoft.NET/Framework/v4.0.30319/csc.exe")
  ;;

  ;; (setq flycheck-csharp-omnisharp-codecheck-executable "C:/Program Files (x86)/MSBuild/12.0/Bin/csc.exe")
  ;; (setq flycheck-csharp-omnisharp-codecheck-executable "C:/Windows/Microsoft.NET/Framework/v4.0.30319/csc.exe")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
