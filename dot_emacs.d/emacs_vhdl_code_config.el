;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-vhdl (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_vhdl_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-vhdl 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ctags/etags management for VHDL (requires exuberant ctags in path)
;; ctags.el --- Exuberant Ctags utilities for Emacs

;; eventually add etags-update.el: a global minor mode that updates TAGS when saving a file.

;; -- ;; (add-hook 'vhdl-mode-hook
;; -- ;; 	  ;; code to be executed only in vhdl-mode
;; -- ;; 	  (
	   
	   ;; The following code is taken from: 
	   ;; URL: https://bitbucket.org/semente/ctags.el
	   (defvar ctags-command "ctags -e -R --languages=vhdl")

	   (defun ctags ()
	     (call-process-shell-command ctags-command nil "*Ctags*"))


	   (defun ctags-find-tags-file ()
	     "Recursively searches each parent directory for a file named
              TAGS and returns the path to that file or nil if a tags file is
              not found or if the buffer is not visiting a file."
	     (progn
	       (defun find-tags-file-r (path)
		 "Find the tags file from current to the parent directories."
		 (let* ((parent-directory (file-name-directory (directory-file-name path)))
			(tags-file-name (concat (file-name-as-directory path) "TAGS")))
		   (cond
		    ((file-exists-p tags-file-name) (throw 'found tags-file-name))
		    ((string= "/TAGS" tags-file-name) nil)
		    (t (find-tags-file-r parent-directory)))))

	       (if (buffer-file-name)
		   (catch 'found
		     (find-tags-file-r (file-name-directory buffer-file-name)))
		 nil)))

	   (defun ctags-set-tags-file ()
	     "Uses `ctags-find-tags-file' to find a TAGS file. If found,
              set 'tags-file-name' with its path or set as nil."
	     (setq-default tags-file-name (ctags-find-tags-file)))

	   (defun ctags-create-tags-table ()
	     (interactive)
	     (let* ((current-directory default-directory)
		    (top-directory (read-directory-name
				    "Top of source tree: " default-directory))
		    (file-name (concat (file-name-as-directory top-directory) "TAGS")))
	       (cd top-directory)
	       (if (not (= 0 (ctags)))
		   (message "Error creating %s!" file-name)
		 (setq-default tags-file-name file-name)
		 (message "Table %s created and configured." tags-file-name))
	       (cd current-directory)))

	   (defun ctags-update-tags-table ()
	     (interactive)
	     (let ((current-directory default-directory))
	       (if (not tags-file-name)
		   (message "Tags table not configured.")
		 (cd (file-name-directory tags-file-name))
		 (if (not (= 0 (ctags)))
		     (message "Error updating %s!" tags-file-name)
		   (message "Table %s updated." tags-file-name))
		 (cd current-directory))))

	   (defun ctags-create-or-update-tags-table ()
	     "Create or update a tags table with `ctags-command'."
	     (interactive)
	     (if (not (ctags-set-tags-file))
		 (ctags-create-tags-table)
	       (ctags-update-tags-table)))


	   (defun ctags-search ()
	     "A wrapper for `tags-search' that provide a default input."
	     (interactive)
	     (let* ((symbol-at-point (symbol-at-point))
		    (default (symbol-name symbol-at-point))
		    (input (read-from-minibuffer
			    (if (symbol-at-point)
				(concat "Tags search (default " default "): ")
			      "Tags search (regexp): "))))
	       (if (and (symbol-at-point) (string= input ""))
		   (tags-search default)
		 (if (string= input "")
		     (message "You must provide a regexp.")
		   (tags-search input)))))
;; -- ;;    )
;; -- ;; 	  
;; -- ;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; speedbar in window

(with-library-for-vhdl sr-speedbar
  (sr-speedbar-open)
  (windmove-default-keybindings)
  (golden-ratio-mode)
  )

;; NOTEs:
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


































;; Undo tree mode

(with-library-for-c ede
  (global-ede-mode)
  )

;; NOTEs:
;;
;; Use to load .el file containing "ede-cpp-root-project" and expand semantics parsing
;; folders.
;;
;; MUST BE ENABLED ON STARTUP TO EXPAND SEMANTICS PARSER!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Autocompletion with CEDET and semantics mode
(with-library-for-c semantic
  (add-hook 'c-mode-hook 'global-semanticdb-minor-mode)
  (add-hook 'c++-mode-hook 'global-semanticdb-minor-mode)
  (add-hook 'c-mode-hook 'global-semantic-idle-completions-mode)
  (add-hook 'c++-mode-hook 'global-semantic-idle-completions-mode)
  (add-hook 'c-mode-hook 'semantic-mode)
  (add-hook 'c++-mode-hook 'semantic-mode))

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

;; Autocompletion with company mode using semantics as backend

(with-library-for-c company
  (add-hook 'after-init-hook 'global-company-mode)
  ;; NOTE: the following "delete" is not necessary if we target the CEDET semantic backend.
  ;; If we want to use the clang (or others backend) we have to delete company-semantic,
  ;; otherwise company-complete will use company-semantic instead of company-clang,
  ;; because it has higher precedence in company-backends.  
  (delete 'company-semantic company-backends)
  (add-hook 'c-mode-hook
	    (lambda() (define-key c-mode-map (kbd "<backtab>") 'company-complete))
	    )
  (add-hook 'c++-mode-hook
	    (lambda() (define-key c++-mode-map (kbd "<backtab>") 'company-complete))
	    )
  )

;; NOTES about company:
;;

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
  (setq sp-base-key-bindings 'paredit)
  (setq sp-autoskip-closing-pair 'always)
  (setq sp-hybrid-kill-entire-symbol nil)
  ;; higlight couples of parentheses
  (add-hook 'c-mode-hook 'show-smartparens-global-mode)
  (add-hook 'c++-mode-hook 'show-smartparens-global-mode)
  (add-hook 'c-mode-hook 'smartparens-global-mode)
  (add-hook 'c++-mode-hook 'smartparens-global-mode)
  )

;; NOTES: about smartparens
;;

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
