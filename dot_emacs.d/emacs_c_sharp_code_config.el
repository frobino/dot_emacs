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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
