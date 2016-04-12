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
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; EDE project management mode (expand semantic backend)

(with-library-for-c ede
  (add-hook 'c-mode-hook 'global-ede-mode)
  (add-hook 'c++-mode-hook 'global-ede-mode)
  (defun ede-new-project (prj_top_folder)
    ;; source: http://ergoemacs.org/emacs/elisp_basics.html
    ;; (interactive "sEnter project top folder: ")
    (interactive (list (read-directory-name "What directory? ")))
    (copy-file "~/.emacs.d/cedet-projects.el" prj_top_folder)
  )
)

;; NOTEs:
;;
;; The EDE project management mode is used to expand semantics parser (i.e. the folders that the semantics parser use to autocomplete). 
;; To use the EDE project management mode, we have to create a cedet-projects.el (use the ede-new-project function)
;; in the root folder of the project (usually the one containing Makefile, src/, header/ folders) and edit it for our project.
;;
;; Then, we have to load cedet-projects.el file (containing "ede-cpp-root-project")
;; so that we can expand semantics parsing folders (M-x load-file cedet-projects.el).
;;
;; global-ede-mode MUST BE ENABLED ON emacs STARTUP TO EXPAND SEMANTICS PARSER!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Autocompletion backend #1: CEDET - semantic mode
(with-library-for-c semantic
  (add-hook 'c-mode-hook 'global-semanticdb-minor-mode)
  (add-hook 'c++-mode-hook 'global-semanticdb-minor-mode)
  (add-hook 'c-mode-hook 'global-semantic-idle-scheduler-mode)
  (add-hook 'c++-mode-hook 'global-semantic-idle-scheduler-mode)
  ;; DANGER: idle completions mode shows completions in idle time automatically...
  ;; Can this be dangerous and conflict with other autocomplete techniques?
  ;; DEACTIVATED AT THE MOMENT. BEST IDEA IS TO USE COMPANY AS FRONTEND AND SWITCH BACKEND.
  ;; (add-hook 'c-mode-hook 'global-semantic-idle-completions-mode)
  ;; (add-hook 'c++-mode-hook 'global-semantic-idle-completions-mode)
  
  ;; The following two are helpful but if activated they give a weird "return" message in buffer sometimes
  (add-hook 'c-mode-hook 'global-semantic-idle-summary-mode) 
  (add-hook 'c++-mode-hook 'global-semantic-idle-summary-mode)

  ;; The following is used to extend semantic to stdio functions, etc. (ex: printf, ...)
  (when mswindows-p
    (add-hook 'c-mode-hook (lambda () (semantic-add-system-include "e:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/include")))
    (add-hook 'c++-mode-hook (lambda () (semantic-add-system-include "e:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/include")))
  )
  ;; What about? :
  ;; '(semantic-c-dependency-system-include-path (quote ("/usr/include")))
  
  (add-hook 'c-mode-hook 'semantic-mode)
  (add-hook 'c++-mode-hook 'semantic-mode) 
  
  )

;; Alternative way (without check):
;;
;; (require 'semantic)
;; (global-semanticdb-minor-mode 1)
;; (global-semantic-idle-completions-mode 1)
;; (semantic-mode 1))

;; NOTES about semantic:
;;
;; You can view the list of include paths in semantic-dependency-system-include-path.
;; To add more include paths, use the function semantic-add-system-include like this:
;;
;; (semantic-add-system-include "/usr/include/boost" 'c++-mode)
;; (semantic-add-system-include "~/linux/kernel")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Autocompletion frontend: company mode with semantic as default backend,
;;                          switch to clang backend with company-other-backend

(with-library-for-c company
  ;; (add-hook 'after-init-hook 'global-company-mode)
  ;; (add-hook 'c-mode-hook 'global-company-mode)
  ;; (add-hook 'c++-mode-hook 'global-company-mode)
  (add-hook 'c-mode-hook #'company-mode)
  (add-hook 'c++-mode-hook #'company-mode)
  
  ;; NOTE: the following "delete" is not necessary if we target the CEDET semantic backend.
  ;; If we want to use the clang (or others backend) we have to delete company-semantic,
  ;; otherwise company-complete will use company-semantic instead of company-clang,
  ;; because it has higher precedence in company-backends.
  ;; (delete 'company-semantic company-backends)
  ;; ---- ;;(add-hook 'c-mode-hook
  ;; ---- ;;          (lambda() (delete 'company-semantic company-backends))
  ;; ---- ;;          )
  ;; ---- ;;(add-hook 'c++-mode-hook
  ;; ---- ;;          (lambda() (delete 'company-semantic company-backends))
  ;; ---- ;;          )
  ;; ---- ;;
  ;; ---- ;;

  ;; default company-complete using semantic
  ;;
  ;; the following seems not needed, and it gives problems with tab indenting
  ;;
  ;; (add-hook 'c-mode-hook
  ;;           (lambda() (define-key c-mode-map [(tab)] 'company-complete))
  ;;           )
  ;; (add-hook 'c++-mode-hook
  ;;           (lambda() (define-key c++-mode-map [(tab)] 'company-complete))
  ;;           )

  ;; select another backend for completion
  (add-hook 'c-mode-hook
            (lambda() (define-key c-mode-map (kbd "<backtab>") 'company-other-backend))
            )
  (add-hook 'c++-mode-hook
            (lambda() (define-key c++-mode-map (kbd "<backtab>") 'company-other-backend))
            )
  
  (defun company-clang-project (prj_top_folder)
    ;; source: http://ergoemacs.org/emacs/elisp_basics.html
    ;; (interactive "sEnter project top folder: ")
    (interactive (list (read-directory-name "What directory? ")))
    (copy-file "~/.emacs.d/dot_dir_locals.el" prj_top_folder)
    (rename-file (concat prj_top_folder "dot_dir_locals.el")  (concat prj_top_folder ".dir-locals.el"))
  )
)

;; NOTES about company with clang backend:
;; - company is just a frontend which can use many different backend to autocomplete. In this case we use clang. 
;; - autocomplete that we get from company-clang comes from the clang libraries.
;; - to extend the company-clang autocomplete function, we can use the company-clang-project function, exactly as ede-new-project for CEDET-semantic

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; function-args: showing an inline arguments hint for the C/C++ function at point.

(with-library-for-c function-args
  (fa-config-default)
  (add-hook 'c-mode-hook
	    (lambda() (define-key c-mode-map [C-tab] 'moo-complete))
	    )
  (add-hook 'c++-mode-hook
	    (lambda() (define-key c++-mode-map [C-tab] 'moo-complete))
	    )
  ;;(define-key c-mode-map (kbd "C-c C-c") 'moo-complete)
  ;;(eval-after-load 'c-mode '(define-key c-mode-map [tab] 'outline-cycle))
  ;;(define-key c-mode-map  [C-tab] 'moo-complete)
  ;;(define-key c++-mode-map  [C-tab] 'moo-complete)
  )

;; Alternative way (without check): 
;;
;; (with-library-for-c function-args
;;   (fa-config-default)
;;   (define-key c-mode-map  [(control tab)] 'moo-complete)
;;   (define-key c++-mode-map  [(control tab)] 'moo-complete)
;;   (define-key c-mode-map (kbd "M-o")  'fa-show)
;;   (define-key c++-mode-map (kbd "M-o")  'fa-show))

;; NOTES about function-args:
;;
;; fa-jump, moo-complete, moo-jump-local are AMAZING functions. Find good key mapping for
;; them and remember to use them

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; hs-minor-mode: fold and hide blocks

(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)

;; NOTES about hs-minor-mode:
;;
;; Main shortcuts:
;; C-c @ C-h: hide a block
;; C-c @ C-s: show a block
;; C-c @ C-M-s: show all blocks
;; C-c @ C-l: hide level

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; sr_speedbar: speedbar in console (not in frame)

(with-library-for-c sr-speedbar
  ;;(add-hook 'c-mode-hook 'sr-speedbar)
  ;;(add-hook 'c++-mode-hook 'global-semanticdb-minor-mode)

  ;; (add-hook 'c-mode-hook (lambda () (require 'sr-speedbar) ))
  ;; (add-hook 'c-mode-hook (lambda () (sr-speedbar-open) ))
  ;; (add-hook 'c-mode-hook (lambda () (when window-system (sr-speedbar-open)) ))

  ;; Whit the following it always open...
  ;; (when window-system (sr-speedbar-open))

  ;; (eval-after-load 'c-mode-hook '(sr-speedbar-open))

  ;; (add-hook 'emacs-startup-hook (lambda () (sr-speedbar-open) ))

  ;; (add-hook 'before-init-hook (lambda () (sr-speedbar-open) ))
  
  ;; (sr-speedbar-open)
  ;; (windmove-default-keybindings)
  ;; (golden-ratio-mode)
  ;; 
  (setq speedbar-show-unknown-files t)
  )

;; NOTES about sr_speedbar
;;
;; Main shortcuts:
;; M-x sr-speedbar-toggle
;; SPC open/close children of a node
;; RET to open

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; company-c-header: auto completion for headers

(with-library-for-c company-c-headers
  (add-to-list 'company-backends 'company-c-headers)
  )

;; NOTES: about company-c-header
;;
;; Add library path with the following:
;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; yasnippet: function templates

(with-library-for-c yasnippet
  (add-hook 'c-mode-hook 'yas-global-mode)
  (add-hook 'c++-mode-hook 'yas-global-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; smartparens: minor mode that deals with parens pairs and tries to be smart about it

(with-library-for-c smartparens
  (add-hook 'c-mode-hook #'smartparens-mode)
  (add-hook 'c++-mode-hook #'smartparens-mode)

  ;; (setq sp-base-key-bindings 'paredit)
  ;; (setq sp-autoskip-closing-pair 'always)
  ;; (setq sp-hybrid-kill-entire-symbol nil)
  ;; ;; higlight couples of parentheses
  ;; (add-hook 'c-mode-hook 'show-smartparens-global-mode)
  ;; (add-hook 'c++-mode-hook 'show-smartparens-global-mode)
  ;; (add-hook 'c-mode-hook 'smartparens-global-mode)
  ;; (add-hook 'c++-mode-hook 'smartparens-global-mode)
  
  )

;; NOTES: about smartparens
;; - activated with # to avoid SP active in other buffers (not C)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ggtags: uses the tag database created by gnu global (GTAGS,GRTAGS,GPATH) to jump around code.
;; REQUIRES "GNU GLOBAL" (GTAGS) INSTALLED

(with-library-for-c ggtags
  (add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

  (define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
  (define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
  (define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
  (define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
  (define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
  (define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

  ;; The main 2 functions
  (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
  (define-key ggtags-mode-map (kbd "M-.") 'ggtags-find-tag-dwim)

  )

;; NOTES about ggtags:
;;
;; to be completed using helm-gtags?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))


;; NOTES: about compilation
;; C-o Display matched location, but do not switch point to matched buffer
;; M-n Move to next error message, but do not visit error location
;; M-p Move to next previous message, but do not visit error location
;; M-g n Move to next error message, visit error location
;; M-g p Move to previous error message, visit error location
;; RET Visit location of error at poiint
;; M-{ Move point to the next error message or match occurring in a different file
;; M-} Move point to the previous error message or match occurring in a different file
;; q Quit *compilation* buffer


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; setup GDB

;; (setq
;;  ;; use gdb-many-windows by default
;;  gdb-many-windows t
;; 
;;  ;; Non-nil means display source file containing the main routine at startup
;;  gdb-show-main t
;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
